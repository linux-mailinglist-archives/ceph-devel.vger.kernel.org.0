Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDE42169EEC
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Feb 2020 08:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgBXHJL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Feb 2020 02:09:11 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24746 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725895AbgBXHJK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 02:09:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582528149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wuk0xNkOKGb8TElORbD7TxsVpvjZ9GgSZDJi8lzLte4=;
        b=VyVf9/Z/66FUYdWlGOkBaeOXdOQ7MEUsVz7GJmbY8vVuEwXfe4f7GmbheNT8nTocE7Giee
        eOQoj7WfLP+hk5+hLwPd9Vx18Sd7cAj5SmIQrtwBvJgF4Q2kLUqOaKd3Gz+/gHEOwRXql7
        COasVctOv/2UgGtq60oQjvQlQf9r7LQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-OO_T3pPdOGmv10uwZvewdQ-1; Mon, 24 Feb 2020 02:09:07 -0500
X-MC-Unique: OO_T3pPdOGmv10uwZvewdQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4994F8010E3;
        Mon, 24 Feb 2020 07:09:06 +0000 (UTC)
Received: from [10.72.13.249] (ovpn-13-249.pek2.redhat.com [10.72.13.249])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6BCF91855;
        Mon, 24 Feb 2020 07:09:04 +0000 (UTC)
Subject: Re: [PATCH v2 2/4] ceph: consider inode's last read/write when
 calculating wanted caps
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20200221131659.87777-1-zyan@redhat.com>
 <20200221131659.87777-3-zyan@redhat.com>
 <1d77fa7876ba37df07c3a8c9dc4c3d8ce4f2538d.camel@kernel.org>
 <21448792f55a51f2b5b0652390ec6e04cbd311af.camel@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <4cdb8f3a-b9f4-9c7d-7ae0-633c0576e0d2@redhat.com>
Date:   Mon, 24 Feb 2020 15:09:02 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <21448792f55a51f2b5b0652390ec6e04cbd311af.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2/21/20 10:35 PM, Jeff Layton wrote:
> On Fri, 2020-02-21 at 09:27 -0500, Jeff Layton wrote:
>> On Fri, 2020-02-21 at 21:16 +0800, Yan, Zheng wrote:
>>> Add i_last_rd and i_last_wr to ceph_inode_info. These two fields are
>>> used to track inode's last read/write, they are updated when getting
>>> caps for read/write.
>>>
>>> If there is no read/write on an inode for 'caps_wanted_delay_max'
>>> seconds, __ceph_caps_file_wanted() does not request caps for read/write
>>> even there are open files.
>>>
>>> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
>>> ---
>>>   fs/ceph/caps.c               | 152 ++++++++++++++++++++++++-----------
>>>   fs/ceph/file.c               |  21 ++---
>>>   fs/ceph/inode.c              |  10 ++-
>>>   fs/ceph/ioctl.c              |   2 +
>>>   fs/ceph/super.h              |  13 ++-
>>>   include/linux/ceph/ceph_fs.h |   1 +
>>>   6 files changed, 139 insertions(+), 60 deletions(-)
>>>
>>> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
>>> index 293920d013ff..2a9df235286d 100644
>>> --- a/fs/ceph/caps.c
>>> +++ b/fs/ceph/caps.c
>>> @@ -971,18 +971,49 @@ int __ceph_caps_used(struct ceph_inode_info *ci)
>>>   	return used;
>>>   }
>>>   
>>> +#define FMODE_WAIT_BIAS 1000
>>> +
>>>   /*
>>>    * wanted, by virtue of open file modes
>>>    */
>>>   int __ceph_caps_file_wanted(struct ceph_inode_info *ci)
>>>   {
>>> -	int i, bits = 0;
>>> -	for (i = 0; i < CEPH_FILE_MODE_BITS; i++) {
>>> -		if (ci->i_nr_by_mode[i])
>>> -			bits |= 1 << i;
>>> +	struct ceph_mount_options *opt =
>>> +		ceph_inode_to_client(&ci->vfs_inode)->mount_options;
>>> +	unsigned long used_cutoff =
>>> +		round_jiffies(jiffies - opt->caps_wanted_delay_max * HZ);
>>> +	unsigned long idle_cutoff =
>>> +		round_jiffies(jiffies - opt->caps_wanted_delay_min * HZ);
>>> +	int bits = 0;
>>> +
>>> +	if (ci->i_nr_by_mode[0] > 0)
>>> +		bits |= CEPH_FILE_MODE_PIN;
>>> +
>>> +	if (ci->i_nr_by_mode[1] > 0) {
>>> +		if (ci->i_nr_by_mode[1] >= FMODE_WAIT_BIAS ||
>>> +		    time_after(ci->i_last_rd, used_cutoff))
>>> +			bits |= CEPH_FILE_MODE_RD;
>>> +	} else if (time_after(ci->i_last_rd, idle_cutoff)) {
>>> +		bits |= CEPH_FILE_MODE_RD;
>>> +	}
>>> +
>>> +	if (ci->i_nr_by_mode[2] > 0) {
>>> +		if (ci->i_nr_by_mode[2] >= FMODE_WAIT_BIAS ||
>>> +		    time_after(ci->i_last_wr, used_cutoff))
>>> +			bits |= CEPH_FILE_MODE_WR;
>>> +	} else if (time_after(ci->i_last_wr, idle_cutoff)) {
>>> +		bits |= CEPH_FILE_MODE_WR;
>>>   	}
>>> +
>>> +	/* check lazyio only when read/write is wanted */
>>> +	if ((bits & CEPH_FILE_MODE_RDWR) && ci->i_nr_by_mode[3] > 0)
>>
>> LAZY is 4. Shouldn't this be?
>>
>>      if ((bits & CEPH_FILE_MODE_RDWR) && ci->i_nr_by_mode[CEPH_FILE_MODE_LAZY] > 0)
>>
> 
> Nope, that value was right, but I think we should phrase this in terms
> of symbolic constants. Maybe we can squash this patch into your series?
> 
> -----------------------8<-----------------------
> 
> [PATCH] SQUASH: use symbolic constants in __ceph_caps_file_wanted()
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/caps.c | 15 ++++++++-------
>   1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index ad365cf870f6..1b450f2195fe 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -971,19 +971,19 @@ int __ceph_caps_file_wanted(struct ceph_inode_info *ci)
>   		round_jiffies(jiffies - opt->caps_wanted_delay_min * HZ);
>   	int bits = 0;
>   
> -	if (ci->i_nr_by_mode[0] > 0)
> +	if (ci->i_nr_by_mode[CEPH_FILE_MODE_PIN] > 0)
>   		bits |= CEPH_FILE_MODE_PIN;
>   
> -	if (ci->i_nr_by_mode[1] > 0) {
> -		if (ci->i_nr_by_mode[1] >= FMODE_WAIT_BIAS ||
> +	if (ci->i_nr_by_mode[CEPH_FILE_MODE_RD] > 0) {
> +		if (ci->i_nr_by_mode[CEPH_FILE_MODE_RD] >= FMODE_WAIT_BIAS ||
>   		    time_after(ci->i_last_rd, used_cutoff))
>   			bits |= CEPH_FILE_MODE_RD;
>   	} else if (time_after(ci->i_last_rd, idle_cutoff)) {
>   		bits |= CEPH_FILE_MODE_RD;
>   	}
>   
> -	if (ci->i_nr_by_mode[2] > 0) {
> -		if (ci->i_nr_by_mode[2] >= FMODE_WAIT_BIAS ||
> +	if (ci->i_nr_by_mode[CEPH_FILE_MODE_WR] > 0) {
> +		if (ci->i_nr_by_mode[CEPH_FILE_MODE_WR] >= FMODE_WAIT_BIAS ||
>   		    time_after(ci->i_last_wr, used_cutoff))
>   			bits |= CEPH_FILE_MODE_WR;
>   	} else if (time_after(ci->i_last_wr, idle_cutoff)) {
> @@ -991,12 +991,13 @@ int __ceph_caps_file_wanted(struct ceph_inode_info *ci)
>   	}
>   
>   	/* check lazyio only when read/write is wanted */
> -	if ((bits & CEPH_FILE_MODE_RDWR) && ci->i_nr_by_mode[3] > 0)
> +	if ((bits & CEPH_FILE_MODE_RDWR) &&
> +	    ci->i_nr_by_mode[ffs(CEPH_FILE_MODE_LAZY)] > 0)
>   		bits |= CEPH_FILE_MODE_LAZY;
>   
>   	if (bits == 0)
>   		return 0;
> -	if (bits == 1 && !S_ISDIR(ci->vfs_inode.i_mode))
> +	if (bits == (1 << CEPH_FILE_MODE_PIN) && !S_ISDIR(ci->vfs_inode.i_mode))
>   		return 0;
>   
>   	return ceph_caps_for_mode(bits >> 1);
> 

how about something like below. when compile with -O2, gcc optimize out 
ffs() functions.

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 2a9df235286d..e1d38ef9478b 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -985,33 +985,38 @@ int __ceph_caps_file_wanted(struct ceph_inode_info 
*ci)
         unsigned long idle_cutoff =
                 round_jiffies(jiffies - opt->caps_wanted_delay_min * HZ);
         int bits = 0;
+       const int PIN_SHIFT = ffs(CEPH_FILE_MODE_PIN);
+       const int RD_SHIFT = ffs(CEPH_FILE_MODE_RD);
+       const int WR_SHIFT= ffs(CEPH_FILE_MODE_WR);
+       const int LAZY_SHIFT = ffs(CEPH_FILE_MODE_LAZY);

-       if (ci->i_nr_by_mode[0] > 0)
-               bits |= CEPH_FILE_MODE_PIN;
+       if (ci->i_nr_by_mode[PIN_SHIFT] > 0)
+               bits |= 1 << PIN_SHIFT;

-       if (ci->i_nr_by_mode[1] > 0) {
-               if (ci->i_nr_by_mode[1] >= FMODE_WAIT_BIAS ||
+       if (ci->i_nr_by_mode[RD_SHIFT] > 0) {
+               if (ci->i_nr_by_mode[RD_SHIFT] >= FMODE_WAIT_BIAS ||
                     time_after(ci->i_last_rd, used_cutoff))
-                       bits |= CEPH_FILE_MODE_RD;
+                       bits |= 1 << RD_SHIFT;
         } else if (time_after(ci->i_last_rd, idle_cutoff)) {
-               bits |= CEPH_FILE_MODE_RD;
+               bits |= 1 << RD_SHIFT;
         }

-       if (ci->i_nr_by_mode[2] > 0) {
-               if (ci->i_nr_by_mode[2] >= FMODE_WAIT_BIAS ||
+       if (ci->i_nr_by_mode[WR_SHIFT] > 0) {
+               if (ci->i_nr_by_mode[WR_SHIFT] >= FMODE_WAIT_BIAS ||
                     time_after(ci->i_last_wr, used_cutoff))
-                       bits |= CEPH_FILE_MODE_WR;
+                       bits |= 1 << WR_SHIFT;
         } else if (time_after(ci->i_last_wr, idle_cutoff)) {
-               bits |= CEPH_FILE_MODE_WR;
+               bits |= 1 << WR_SHIFT;
         }

         /* check lazyio only when read/write is wanted */
-       if ((bits & CEPH_FILE_MODE_RDWR) && ci->i_nr_by_mode[3] > 0)
-               bits |= CEPH_FILE_MODE_LAZY;
+       if ((bits & (CEPH_FILE_MODE_RDWR << 1)) &&
+           ci->i_nr_by_mode[LAZY_SHIFT] > 0)
+               bits |= 1 << LAZY_SHIFT;

         if (bits == 0)
                 return 0;
-       if (bits == 1 && !S_ISDIR(ci->vfs_inode.i_mode))
+       if (bits == (1 << PIN_SHIFT) && !S_ISDIR(ci->vfs_inode.i_mode))
                 return 0;

         return ceph_caps_for_mode(bits >> 1);


