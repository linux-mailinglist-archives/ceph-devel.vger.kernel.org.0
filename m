Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79599498F2
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Jun 2019 08:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbfFRGlo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Jun 2019 02:41:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51240 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbfFRGln (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 02:41:43 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A578589AD0
        for <ceph-devel@vger.kernel.org>; Tue, 18 Jun 2019 06:25:26 +0000 (UTC)
Received: from [10.72.12.188] (ovpn-12-188.pek2.redhat.com [10.72.12.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A54F362926;
        Tue, 18 Jun 2019 06:25:23 +0000 (UTC)
Subject: Re: [PATCH 4/8] ceph: allow remounting aborted mount
To:     Jeff Layton <jlayton@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@redhat.com
References: <20190617125529.6230-1-zyan@redhat.com>
 <20190617125529.6230-5-zyan@redhat.com>
 <86f838f18f0871d6c21ae7bfb97541f1de8d918f.camel@redhat.com>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <3b0a4024-d47e-0a3f-48ca-0f1f657e9da9@redhat.com>
Date:   Tue, 18 Jun 2019 14:25:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <86f838f18f0871d6c21ae7bfb97541f1de8d918f.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 18 Jun 2019 06:25:26 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 6/18/19 1:30 AM, Jeff Layton wrote:
> On Mon, 2019-06-17 at 20:55 +0800, Yan, Zheng wrote:
>> When remounting aborted mount, also reset client's entity addr.
>> 'umount -f /ceph; mount -o remount /ceph' can be used for recovering
>> from blacklist.
>>
> 
> Why do I need to umount here? Once the filesystem is unmounted, then the
> '-o remount' becomes superfluous, no? In fact, I get an error back when
> I try to remount an unmounted filesystem:
> 
>      $ sudo umount -f /mnt/cephfs ; sudo mount -o remount /mnt/cephfs
>      mount: /mnt/cephfs: mount point not mounted or bad option.
> 
> My client isn't blacklisted above, so I guess you're counting on the
> umount returning without having actually unmounted the filesystem?
> 
> I think this ought to not need a umount first. From a UI standpoint,
> just doing a "mount -o remount" ought to be sufficient to clear this.
> 

If just doing "mount -o remount", user will expect there is no 
data/metadata get lost.  The 'mount -f' explicitly tell user this 
operation may lose data/metadata.


> Also, how would an admin know that this is something they ought to try?
> Is there a way for them to know that their client has been blacklisted?
> 
>> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 16 +++++++++++++---
>>   fs/ceph/super.c      | 23 +++++++++++++++++++++--
>>   2 files changed, 34 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 19c62cf7d5b8..188c33709d9a 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -1378,9 +1378,12 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
>>   		struct ceph_cap_flush *cf;
>>   		struct ceph_mds_client *mdsc = fsc->mdsc;
>>   
>> -		if (ci->i_wrbuffer_ref > 0 &&
>> -		    READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN)
>> -			invalidate = true;
>> +		if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
>> +			if (inode->i_data.nrpages > 0)
>> +				invalidate = true;
>> +			if (ci->i_wrbuffer_ref > 0)
>> +				mapping_set_error(&inode->i_data, -EIO);
>> +		}
>>   
>>   		while (!list_empty(&ci->i_cap_flush_list)) {
>>   			cf = list_first_entry(&ci->i_cap_flush_list,
>> @@ -4350,7 +4353,12 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
>>   		session = __ceph_lookup_mds_session(mdsc, mds);
>>   		if (!session)
>>   			continue;
>> +
>> +		if (session->s_state == CEPH_MDS_SESSION_REJECTED)
>> +			__unregister_session(mdsc, session);
>> +		__wake_requests(mdsc, &session->s_waiting);
>>   		mutex_unlock(&mdsc->mutex);
>> +
>>   		mutex_lock(&session->s_mutex);
>>   		__close_session(mdsc, session);
>>   		if (session->s_state == CEPH_MDS_SESSION_CLOSING) {
>> @@ -4359,9 +4367,11 @@ void ceph_mdsc_force_umount(struct ceph_mds_client *mdsc)
>>   		}
>>   		mutex_unlock(&session->s_mutex);
>>   		ceph_put_mds_session(session);
>> +
>>   		mutex_lock(&mdsc->mutex);
>>   		kick_requests(mdsc, mds);
>>   	}
>> +
>>   	__wake_requests(mdsc, &mdsc->waiting_for_map);
>>   	mutex_unlock(&mdsc->mutex);
>>   }
>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>> index 67eb9d592ab7..a6a3c065f697 100644
>> --- a/fs/ceph/super.c
>> +++ b/fs/ceph/super.c
>> @@ -833,8 +833,27 @@ static void ceph_umount_begin(struct super_block *sb)
>>   
>>   static int ceph_remount(struct super_block *sb, int *flags, char *data)
>>   {
>> -	sync_filesystem(sb);
>> -	return 0;
>> +	struct ceph_fs_client *fsc = ceph_sb_to_client(sb);
>> +
>> +	if (fsc->mount_state != CEPH_MOUNT_SHUTDOWN) {
>> +		sync_filesystem(sb);
>> +		return 0;
>> +	}
>> +
>> +	/* Make sure all page caches get invalidated.
>> +	 * see remove_session_caps_cb() */
>> +	flush_workqueue(fsc->inode_wq);
>> +	/* In case that we were blacklisted. This also reset
>> +	 * all mon/osd connections */
>> +	ceph_reset_client_addr(fsc->client);
>> +
>> +	ceph_osdc_clear_abort_err(&fsc->client->osdc);
>> +	fsc->mount_state = 0;
>> +
>> +	if (!sb->s_root)
>> +		return 0;
>> +	return __ceph_do_getattr(d_inode(sb->s_root), NULL,
>> +				 CEPH_STAT_CAP_INODE, true);
>>   }
>>   
>>   static const struct super_operations ceph_super_ops = {
> 

