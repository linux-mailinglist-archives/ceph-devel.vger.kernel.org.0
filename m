Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79F89168BD7
	for <lists+ceph-devel@lfdr.de>; Sat, 22 Feb 2020 02:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbgBVBvm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Feb 2020 20:51:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30211 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726842AbgBVBvm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 21 Feb 2020 20:51:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582336301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6v1RJWDgZh7vSlWxZVdqzaU089Q2t655hpLmv8En4Dk=;
        b=ZzabvNx+jkicV9TxfeUymvI0egLow9fkKpN5pf4gb0iK1TrPyAt3wYwr70Egdkc+M/vf6m
        FIh3xA5xUCvrmeeY5zV1ZeDvO14lrlRJmjft4wg2+2H9X34v4S4tubypxvn5OS4x4KDK2o
        aSF/WDfbWQL2S93gZsVMimP60gWor80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-LOrycu2tNcyhKGPXTWx9SA-1; Fri, 21 Feb 2020 20:51:34 -0500
X-MC-Unique: LOrycu2tNcyhKGPXTWx9SA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E68E107ACC7;
        Sat, 22 Feb 2020 01:51:33 +0000 (UTC)
Received: from [10.72.12.94] (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 02ADB5D9E2;
        Sat, 22 Feb 2020 01:51:27 +0000 (UTC)
Subject: Re: [PATCH v8 2/5] ceph: add caps perf metric for each session
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20200221070556.18922-1-xiubli@redhat.com>
 <20200221070556.18922-3-xiubli@redhat.com>
 <a654d3d4765741594e9c49ef62ba1d0ab41e3960.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ff394699-2de4-c3ba-9b11-0730acf7d4df@redhat.com>
Date:   Sat, 22 Feb 2020 09:51:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <a654d3d4765741594e9c49ef62ba1d0ab41e3960.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/21 20:00, Jeff Layton wrote:
> On Fri, 2020-02-21 at 02:05 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will fulfill the cap hit/mis metric stuff per-superblock,
>> it will count the hit/mis counters based each inode, and if one
>> inode's 'issued & ~revoking == mask' will mean a hit, or a miss.
>>
>> item          total           miss            hit
>> -------------------------------------------------
>> caps          295             107             4119
>>
>> URL: https://tracker.ceph.com/issues/43215
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/acl.c        |  2 +-
>>   fs/ceph/caps.c       | 19 +++++++++++++++++++
>>   fs/ceph/debugfs.c    | 16 ++++++++++++++++
>>   fs/ceph/dir.c        |  5 +++--
>>   fs/ceph/inode.c      |  4 ++--
>>   fs/ceph/mds_client.c | 26 ++++++++++++++++++++++----
>>   fs/ceph/metric.h     | 19 +++++++++++++++++++
>>   fs/ceph/super.h      |  8 +++++---
>>   fs/ceph/xattr.c      |  4 ++--
>>   9 files changed, 89 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/ceph/acl.c b/fs/ceph/acl.c
>> index 26be6520d3fb..e0465741c591 100644
>> --- a/fs/ceph/acl.c
>> +++ b/fs/ceph/acl.c
>> @@ -22,7 +22,7 @@ static inline void ceph_set_cached_acl(struct inode *inode,
>>   	struct ceph_inode_info *ci = ceph_inode(inode);
>>   
>>   	spin_lock(&ci->i_ceph_lock);
>> -	if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0))
>> +	if (__ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 0))
>>   		set_cached_acl(inode, type, acl);
>>   	else
>>   		forget_cached_acl(inode, type);
> nit: calling __ceph_caps_issued_mask_metric means that you have an extra
> branch. One to set/forget acl and one to update the counter.
>
> This would be (very slightly) more efficient if you just put the cap
> hit/miss calls inside the existing if block above. IOW, you could just
> do:
>
> if (__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 0)) {
> 	set_cached_acl(inode, type, acl);
> 	ceph_update_cap_hit(&fsc->mdsc->metric);
> } else {
> 	forget_cached_acl(inode, type);
> 	ceph_update_cap_mis(&fsc->mdsc->metric);
> }

Yeah, this will works well here.


>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>> index ff1714fe03aa..227949c3deb8 100644
>> --- a/fs/ceph/dir.c
>> +++ b/fs/ceph/dir.c
>> @@ -346,8 +346,9 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   	    !ceph_test_mount_opt(fsc, NOASYNCREADDIR) &&
>>   	    ceph_snap(inode) != CEPH_SNAPDIR &&
>>   	    __ceph_dir_is_complete_ordered(ci) &&
>> -	    __ceph_caps_issued_mask(ci, CEPH_CAP_FILE_SHARED, 1)) {
>> +	    __ceph_caps_issued_mask_metric(ci, CEPH_CAP_FILE_SHARED, 1)) {
> These could also just be cap_hit/mis calls inside the existing if
> blocks.

Yeah, right in the if branch we can be sure that the 
__ceph_caps_issued_mask() is called. But in the else branch we still 
need to get the return value from (rc = __ceph_caps_issued_mask()), and 
only when "rc == 0" cap_mis will need. This could simplify the code here 
and below.

This is main reason to add the __ceph_caps_issued_mask_metric() here. 
And if you do not like this approach I will switch it back :-)

>
>> @@ -7,5 +7,24 @@ struct ceph_client_metric {
>>   	atomic64_t            total_dentries;
>>   	struct percpu_counter d_lease_hit;
>>   	struct percpu_counter d_lease_mis;
>> +
>> +	struct percpu_counter i_caps_hit;
>> +	struct percpu_counter i_caps_mis;
>>   };
>> +
>> +static inline void ceph_update_cap_hit(struct ceph_client_metric *m)
>> +{
>> +	if (!m)
>> +		return;
>> +
> When are these ever NULL?

Will delete it.

Thanks

BRs

>
>> +	percpu_counter_inc(&m->i_caps_hit);
>> +}
>> +
>> +static inline void ceph_update_cap_mis(struct ceph_client_metric *m)
>> +{
>> +	if (!m)
>> +		return;
>> +
>> +	percpu_counter_inc(&m->i_caps_mis);
>> +}
>>   #endif /* _FS_CEPH_MDS_METRIC_H */
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index ebcf7612eac9..4b269dc845bb 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -639,6 +639,8 @@ static inline bool __ceph_is_any_real_caps(struct ceph_inode_info *ci)
>>   
>>   extern int __ceph_caps_issued(struct ceph_inode_info *ci, int *implemented);
>>   extern int __ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask, int t);
>> +extern int __ceph_caps_issued_mask_metric(struct ceph_inode_info *ci, int mask,
>> +					  int t);
>>   extern int __ceph_caps_issued_other(struct ceph_inode_info *ci,
>>   				    struct ceph_cap *cap);
>>   
>> @@ -651,12 +653,12 @@ static inline int ceph_caps_issued(struct ceph_inode_info *ci)
>>   	return issued;
>>   }
>>   
>> -static inline int ceph_caps_issued_mask(struct ceph_inode_info *ci, int mask,
>> -					int touch)
>> +static inline int ceph_caps_issued_mask_metric(struct ceph_inode_info *ci,
>> +					       int mask, int touch)
>>   {
>>   	int r;
>>   	spin_lock(&ci->i_ceph_lock);
>> -	r = __ceph_caps_issued_mask(ci, mask, touch);
>> +	r = __ceph_caps_issued_mask_metric(ci, mask, touch);
>>   	spin_unlock(&ci->i_ceph_lock);
>>   	return r;
>>   }
>> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
>> index 7b8a070a782d..71ee34d160c3 100644
>> --- a/fs/ceph/xattr.c
>> +++ b/fs/ceph/xattr.c
>> @@ -856,7 +856,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>>   
>>   	if (ci->i_xattrs.version == 0 ||
>>   	    !((req_mask & CEPH_CAP_XATTR_SHARED) ||
>> -	      __ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1))) {
>> +	      __ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 1))) {
>>   		spin_unlock(&ci->i_ceph_lock);
>>   
>>   		/* security module gets xattr while filling trace */
>> @@ -914,7 +914,7 @@ ssize_t ceph_listxattr(struct dentry *dentry, char *names, size_t size)
>>   	     ci->i_xattrs.version, ci->i_xattrs.index_version);
>>   
>>   	if (ci->i_xattrs.version == 0 ||
>> -	    !__ceph_caps_issued_mask(ci, CEPH_CAP_XATTR_SHARED, 1)) {
>> +	    !__ceph_caps_issued_mask_metric(ci, CEPH_CAP_XATTR_SHARED, 1)) {
>>   		spin_unlock(&ci->i_ceph_lock);
>>   		err = ceph_do_getattr(inode, CEPH_STAT_CAP_XATTR, true);
>>   		if (err)


