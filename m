Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B01652962C
	for <lists+ceph-devel@lfdr.de>; Tue, 17 May 2022 02:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236183AbiEQAsa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 16 May 2022 20:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234935AbiEQAs3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 16 May 2022 20:48:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C88E34B96
        for <ceph-devel@vger.kernel.org>; Mon, 16 May 2022 17:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652748505;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YC6OBWobZMrbGR4AIcWhhSaEuv+yl43a5W5WM1ud1do=;
        b=jR+YYMiEcvpKF2KnWS/q7KVaIkLKNEjMdq1cl/BFMymG5odi3AyoAOyL1aQgAkENmkXTTA
        IMQkH0wo1bBYVCeicwBTFzBsDgZRCiixY4e3wufjM+BcNi0W4QUY/VMxZejTrvxDU15/wy
        n5NCYwz5KgVJOfwWomfN6yxoPEo9myA=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-FwvIXPeZMS-ZmeGhbB-rNg-1; Mon, 16 May 2022 20:48:23 -0400
X-MC-Unique: FwvIXPeZMS-ZmeGhbB-rNg-1
Received: by mail-pg1-f197.google.com with SMTP id q13-20020a638c4d000000b003821725ad66so8080439pgn.23
        for <ceph-devel@vger.kernel.org>; Mon, 16 May 2022 17:48:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YC6OBWobZMrbGR4AIcWhhSaEuv+yl43a5W5WM1ud1do=;
        b=2DUQKn9fVwkLHpqrZmbOzks4HwkpeYqgd+BKr8pWfyIlPHjyD/X3YqaqTEUsWbeycr
         qwUX/tmK6D82xIXcuTP1zT93xLObf8uGAbfd4WFDbVHm/2gx8T9h3YukjgQTn1acYgXT
         gGsVc0xLgxk9bZAsjpoOd7yas6bEbeaygyWHtnWeQ7tCZiMR+6WL8P6UVaP7HnxZuz4a
         OiOgdP8tJK0lpXUQD/ybEb+/E5EmhHFjFK4MuPP2PuV4cmXZfPJ/UMtOi5v7luAszm4r
         qloLc0C1O43hPJL8kHEMKRmHr4FhXdKyGdwwh/s4eavGlRmY4La2Hwq7SIf3pmU4w0LO
         JX3A==
X-Gm-Message-State: AOAM530a3cFho+0jhEYTTdgMKrA1RJjBK97xXDCSpiij3ZpJr1fHYh8Y
        ao6iurjOz7EC1MCq0cD6XY6mcx0p4GgAoR8AkeKQtmv+AOqHvIpiER2rsS5lWHODOjyYCpVpTKl
        hxNnxfgDSpUqyGDf/dGHNsQ==
X-Received: by 2002:a63:db17:0:b0:3c1:dc15:7a6e with SMTP id e23-20020a63db17000000b003c1dc157a6emr17803879pgg.107.1652748502469;
        Mon, 16 May 2022 17:48:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0cDCfvn0UWzDBJGF3mwEwLLoqi6s9rJKUNQEGAkwvLe3+xvfpdM8Y6CkhYMmH3nDCbjzmgg==
X-Received: by 2002:a63:db17:0:b0:3c1:dc15:7a6e with SMTP id e23-20020a63db17000000b003c1dc157a6emr17803850pgg.107.1652748502013;
        Mon, 16 May 2022 17:48:22 -0700 (PDT)
Received: from [10.72.12.136] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l3-20020a17090aaa8300b001d5943e826asm292883pjq.20.2022.05.16.17.48.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 17:48:21 -0700 (PDT)
Subject: Re: [PATCH 2/2] ceph: wait the first reply of inflight unlink/rmdir
To:     Jeff Layton <jlayton@kernel.org>, viro@zeniv.linux.org.uk
Cc:     idryomov@gmail.com, vshankar@redhat.com,
        ceph-devel@vger.kernel.org, mcgrof@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220516122046.40655-1-xiubli@redhat.com>
 <20220516122046.40655-3-xiubli@redhat.com>
 <ea6eef767ae6bcdf7aeae7bbc00c2dd89f8c7e5f.camel@kernel.org>
 <7a37f7a3-586b-5b75-3692-dc391f737a6b@redhat.com>
 <c0db7d53099d171e8abd5df07c1c177ce22fc303.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <575461a6-2e6c-a4ab-6fd0-966ce01bafd0@redhat.com>
Date:   Tue, 17 May 2022 08:48:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c0db7d53099d171e8abd5df07c1c177ce22fc303.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/17/22 12:58 AM, Jeff Layton wrote:
> On Mon, 2022-05-16 at 22:56 +0800, Xiubo Li wrote:
>> On 5/16/22 9:23 PM, Jeff Layton wrote:
>>> On Mon, 2022-05-16 at 20:20 +0800, Xiubo Li wrote:
>>>> In async unlink case the kclient won't wait for the first reply
>>>> from MDS and just drop all the links and unhash the dentry and then
>>>> succeeds immediately.
>>>>
>>>> For any new create/link/rename,etc requests followed by using the
>>>> same file names we must wait for the first reply of the inflight
>>>> unlink request, or the MDS possibly will fail these following
>>>> requests with -EEXIST if the inflight async unlink request was
>>>> delayed for some reasons.
>>>>
>>>> And the worst case is that for the none async openc request it will
>>>> successfully open the file if the CDentry hasn't been unlinked yet,
>>>> but later the previous delayed async unlink request will remove the
>>>> CDenty. That means the just created file is possiblly deleted later
>>>> by accident.
>>>>
>>>> We need to wait for the inflight async unlink requests to finish
>>>> when creating new files/directories by using the same file names.
>>>>
>>>> URL: https://tracker.ceph.com/issues/55332
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>    fs/ceph/dir.c        | 55 +++++++++++++++++++++++++++++++----
>>>>    fs/ceph/file.c       |  5 ++++
>>>>    fs/ceph/mds_client.c | 69 ++++++++++++++++++++++++++++++++++++++++++++
>>>>    fs/ceph/mds_client.h |  1 +
>>>>    fs/ceph/super.c      |  2 ++
>>>>    fs/ceph/super.h      | 18 ++++++++----
>>>>    6 files changed, 140 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>>>> index eae417d71136..20c648406528 100644
>>>> --- a/fs/ceph/dir.c
>>>> +++ b/fs/ceph/dir.c
>>>> @@ -856,6 +856,10 @@ static int ceph_mknod(struct user_namespace *mnt_userns, struct inode *dir,
>>>>    	if (ceph_snap(dir) != CEPH_NOSNAP)
>>>>    		return -EROFS;
>>>>    
>>>> +	err = ceph_wait_on_conflict_unlink(dentry);
>>>> +	if (err)
>>>> +		return err;
>>>> +
>>>>    	if (ceph_quota_is_max_files_exceeded(dir)) {
>>>>    		err = -EDQUOT;
>>>>    		goto out;
>>>> @@ -918,6 +922,10 @@ static int ceph_symlink(struct user_namespace *mnt_userns, struct inode *dir,
>>>>    	if (ceph_snap(dir) != CEPH_NOSNAP)
>>>>    		return -EROFS;
>>>>    
>>>> +	err = ceph_wait_on_conflict_unlink(dentry);
>>>> +	if (err)
>>>> +		return err;
>>>> +
>>>>    	if (ceph_quota_is_max_files_exceeded(dir)) {
>>>>    		err = -EDQUOT;
>>>>    		goto out;
>>>> @@ -968,9 +976,13 @@ static int ceph_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
>>>>    	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(dir->i_sb);
>>>>    	struct ceph_mds_request *req;
>>>>    	struct ceph_acl_sec_ctx as_ctx = {};
>>>> -	int err = -EROFS;
>>>> +	int err;
>>>>    	int op;
>>>>    
>>>> +	err = ceph_wait_on_conflict_unlink(dentry);
>>>> +	if (err)
>>>> +		return err;
>>>> +
>>>>    	if (ceph_snap(dir) == CEPH_SNAPDIR) {
>>>>    		/* mkdir .snap/foo is a MKSNAP */
>>>>    		op = CEPH_MDS_OP_MKSNAP;
>>>> @@ -980,6 +992,7 @@ static int ceph_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
>>>>    		dout("mkdir dir %p dn %p mode 0%ho\n", dir, dentry, mode);
>>>>    		op = CEPH_MDS_OP_MKDIR;
>>>>    	} else {
>>>> +		err = -EROFS;
>>>>    		goto out;
>>>>    	}
>>>>    
>>>> @@ -1037,6 +1050,10 @@ static int ceph_link(struct dentry *old_dentry, struct inode *dir,
>>>>    	struct ceph_mds_request *req;
>>>>    	int err;
>>>>    
>>>> +	err = ceph_wait_on_conflict_unlink(dentry);
>>>> +	if (err)
>>>> +		return err;
>>>> +
>>>>    	if (ceph_snap(dir) != CEPH_NOSNAP)
>>>>    		return -EROFS;
>>>>    
>>>> @@ -1071,9 +1088,24 @@ static int ceph_link(struct dentry *old_dentry, struct inode *dir,
>>>>    static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
>>>>    				 struct ceph_mds_request *req)
>>>>    {
>>>> +	struct dentry *dentry = req->r_dentry;
>>>> +	struct ceph_dentry_info *di = ceph_dentry(dentry);
>>>>    	int result = req->r_err ? req->r_err :
>>>>    			le32_to_cpu(req->r_reply_info.head->result);
>>>>    
>>>> +	if (test_bit(CEPH_DENTRY_ASYNC_UNLINK_BIT, &di->flags)) {
>>>> +		BUG_ON(req->r_op != CEPH_MDS_OP_UNLINK);
>>>> +
>>>> +		hash_del_rcu(&di->hnode);
>>>> +
>>>> +		spin_lock(&dentry->d_lock);
>>>> +		di->flags &= ~CEPH_DENTRY_ASYNC_UNLINK;
>>>> +		wake_up_bit(&di->flags, CEPH_DENTRY_ASYNC_UNLINK_BIT);
>>>> +		spin_unlock(&dentry->d_lock);
>>>> +
>>>> +		synchronize_rcu();
>>>> +	}
>>>> +
>>>>    	if (result == -EJUKEBOX)
>>>>    		goto out;
>>>>    
>>>> @@ -1081,7 +1113,7 @@ static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
>>>>    	if (result) {
>>>>    		int pathlen = 0;
>>>>    		u64 base = 0;
>>>> -		char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
>>>> +		char *path = ceph_mdsc_build_path(dentry, &pathlen,
>>>>    						  &base, 0);
>>>>    
>>>>    		/* mark error on parent + clear complete */
>>>> @@ -1089,13 +1121,13 @@ static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
>>>>    		ceph_dir_clear_complete(req->r_parent);
>>>>    
>>>>    		/* drop the dentry -- we don't know its status */
>>>> -		if (!d_unhashed(req->r_dentry))
>>>> -			d_drop(req->r_dentry);
>>>> +		if (!d_unhashed(dentry))
>>>> +			d_drop(dentry);
>>>>    
>>>>    		/* mark inode itself for an error (since metadata is bogus) */
>>>>    		mapping_set_error(req->r_old_inode->i_mapping, result);
>>>>    
>>>> -		pr_warn("ceph: async unlink failure path=(%llx)%s result=%d!\n",
>>>> +		pr_warn("async unlink failure path=(%llx)%s result=%d!\n",
>>>>    			base, IS_ERR(path) ? "<<bad>>" : path, result);
>>>>    		ceph_mdsc_free_path(path, pathlen);
>>>>    	}
>>>> @@ -1189,12 +1221,21 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
>>>>    		ihold(req->r_old_inode);
>>>>    		err = ceph_mdsc_submit_request(mdsc, dir, req);
>>>>    		if (!err) {
>>>> +			struct ceph_dentry_info *di;
>>>> +
>>>>    			/*
>>>>    			 * We have enough caps, so we assume that the unlink
>>>>    			 * will succeed. Fix up the target inode and dcache.
>>>>    			 */
>>>>    			drop_nlink(inode);
>>>>    			d_delete(dentry);
>>>> +
>>>> +			spin_lock(&dentry->d_lock);
>>>> +			di = ceph_dentry(dentry);
>>>> +			di->flags |= CEPH_DENTRY_ASYNC_UNLINK;
>>>> +			hash_add_rcu(fsc->async_unlink_conflict, &di->hnode,
>>>> +				     dentry->d_name.hash);
>>>> +			spin_unlock(&dentry->d_lock);
>>> This looks racy. It's possible that the reply comes in before we get to
>>> the point of setting this flag. You probably want to do this before
>>> calling ceph_mdsc_submit_request, and just unwind it if the submission
>>> fails.
>> Ah, right. Will fix it.
>>
>>
>>> Also, you do still need some sort of lock to protect the
>>> hash_add/del/_rcu calls.
>> Sure, will fix it too.
>>
>>>    Those don't do any locking on their own. The
>>> d_lock is insufficient here since it can't protect the whole list. You
>>> may be able to use the i_ceph_lock of the parent though?
>> The hashtable is a global one, so we couldn't use the i_ceph_lock here.
>> I will add one dedicated spin lock for each sb.
>>
>>>>    		} else if (err == -EJUKEBOX) {
>>>>    			try_async = false;
>>>>    			ceph_mdsc_put_request(req);
>>>> @@ -1237,6 +1278,10 @@ static int ceph_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
>>>>    	    (!ceph_quota_is_same_realm(old_dir, new_dir)))
>>>>    		return -EXDEV;
>>>>    
>>>> +	err = ceph_wait_on_conflict_unlink(new_dentry);
>>>> +	if (err)
>>>> +		return err;
>>>> +
>>>>    	dout("rename dir %p dentry %p to dir %p dentry %p\n",
>>>>    	     old_dir, old_dentry, new_dir, new_dentry);
>>>>    	req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
>>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>>> index 8c8226c0feac..47d068e6436a 100644
>>>> --- a/fs/ceph/file.c
>>>> +++ b/fs/ceph/file.c
>>>> @@ -740,6 +740,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>>>>    	if (dentry->d_name.len > NAME_MAX)
>>>>    		return -ENAMETOOLONG;
>>>>    
>>>> +	err = ceph_wait_on_conflict_unlink(dentry);
>>>> +	if (err)
>>>> +		return err;
>>>> +
>>> What might be nice here eventually is to not block an async create here,
>>> but instead queue the request so that it gets transmitted after the
>>> async unlink reply comes in.
>>>
>>> That'll be hard to get right though, so this is fine for now.
>> Sure.
>>
>>>>    	if (flags & O_CREAT) {
>>>>    		if (ceph_quota_is_max_files_exceeded(dir))
>>>>    			return -EDQUOT;
>>>> @@ -757,6 +761,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>>>>    		/* If it's not being looked up, it's negative */
>>>>    		return -ENOENT;
>>>>    	}
>>>> +
>>>>    retry:
>>>>    	/* do the open */
>>>>    	req = prepare_open_request(dir->i_sb, flags, mode);
>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>> index e8c87dea0551..0ae0e0110eb4 100644
>>>> --- a/fs/ceph/mds_client.c
>>>> +++ b/fs/ceph/mds_client.c
>>>> @@ -468,6 +468,75 @@ static int ceph_parse_deleg_inos(void **p, void *end,
>>>>    	return -EIO;
>>>>    }
>>>>    
>>>> +/*
>>>> + * In async unlink case the kclient won't wait for the first reply
>>>> + * from MDS and just drop all the links and unhash the dentry and then
>>>> + * succeeds immediately.
>>>> + *
>>>> + * For any new create/link/rename,etc requests followed by using the
>>>> + * same file names we must wait for the first reply of the inflight
>>>> + * unlink request, or the MDS possibly will fail these following
>>>> + * requests with -EEXIST if the inflight async unlink request was
>>>> + * delayed for some reasons.
>>>> + *
>>>> + * And the worst case is that for the none async openc request it will
>>>> + * successfully open the file if the CDentry hasn't been unlinked yet,
>>>> + * but later the previous delayed async unlink request will remove the
>>>> + * CDenty. That means the just created file is possiblly deleted later
>>>> + * by accident.
>>>> + *
>>>> + * We need to wait for the inflight async unlink requests to finish
>>>> + * when creating new files/directories by using the same file names.
>>>> + */
>>>> +int ceph_wait_on_conflict_unlink(struct dentry *dentry)
>>>> +{
>>>> +	struct ceph_fs_client *fsc = ceph_sb_to_client(dentry->d_sb);
>>>> +	struct dentry *pdentry = dentry->d_parent;
>>>> +	struct dentry *udentry, *found = NULL;
>>>> +	struct ceph_dentry_info *di;
>>>> +	struct qstr dname;
>>>> +	u32 hash = dentry->d_name.hash;
>>>> +	int err;
>>>> +
>>>> +	dname.name = dentry->d_name.name;
>>>> +	dname.len = dentry->d_name.len;
>>>> +
>>>> +	rcu_read_lock();
>>>> +	hash_for_each_possible_rcu(fsc->async_unlink_conflict, di,
>>>> +				   hnode, hash) {
>>>> +		udentry = di->dentry;
>>>> +
>>>> +		spin_lock(&udentry->d_lock);
>>>> +		if (udentry->d_name.hash != hash)
>>>> +			goto next;
>>>> +		if (unlikely(udentry->d_parent != pdentry))
>>>> +			goto next;
>>>> +		if (!hash_hashed(&di->hnode))
>>>> +			goto next;
>>>> +
>>>> +		if (!test_bit(CEPH_DENTRY_ASYNC_UNLINK_BIT, &di->flags))
>>>> +			goto next;
>>>> +
>>> Maybe this should be a warning? Will we ever have entries in this
>>> hashtable that don't have this bit set?
>> Just before we take "spin_lock(&udentry->d_lock)" the udentry could be
>> already removed from hashtable and the bit was cleared ?
>>
>>
>
> The point is that you're removing the dentry from the hash before you
> clear the flag, so there should never be a dentry in the hash that has
> the flag cleared.
>
Yeah, makes sense. Will make it a warning here.

-- XIubo


>>>> +		if (d_compare(pdentry, udentry, &dname))
>>>> +			goto next;
>>>> +
>>>> +		spin_unlock(&udentry->d_lock);
>>>> +		found = dget(udentry);
>>>> +		break;
>>>> +next:
>>>> +		spin_unlock(&udentry->d_lock);
>>>> +	}
>>>> +	rcu_read_unlock();
>>>> +
>>>> +	if (likely(!found))
>>>> +		return 0;
>>>> +
>>>> +	err = wait_on_bit(&di->flags, CEPH_DENTRY_ASYNC_UNLINK_BIT,
>>>> +			  TASK_INTERRUPTIBLE);
>>>> +	dput(found);
>>>> +	return err;
>>>> +}
>>>> +
>>>>    u64 ceph_get_deleg_ino(struct ceph_mds_session *s)
>>>>    {
>>>>    	unsigned long ino;
>>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>>>> index 33497846e47e..d1ae679c52c3 100644
>>>> --- a/fs/ceph/mds_client.h
>>>> +++ b/fs/ceph/mds_client.h
>>>> @@ -582,6 +582,7 @@ static inline int ceph_wait_on_async_create(struct inode *inode)
>>>>    			   TASK_INTERRUPTIBLE);
>>>>    }
>>>>    
>>>> +extern int ceph_wait_on_conflict_unlink(struct dentry *dentry);
>>>>    extern u64 ceph_get_deleg_ino(struct ceph_mds_session *session);
>>>>    extern int ceph_restore_deleg_ino(struct ceph_mds_session *session, u64 ino);
>>>>    #endif
>>>> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
>>>> index b73b4f75462c..7ae65001f04c 100644
>>>> --- a/fs/ceph/super.c
>>>> +++ b/fs/ceph/super.c
>>>> @@ -816,6 +816,8 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
>>>>    	if (!fsc->cap_wq)
>>>>    		goto fail_inode_wq;
>>>>    
>>>> +	hash_init(fsc->async_unlink_conflict);
>>>> +
>>>>    	spin_lock(&ceph_fsc_lock);
>>>>    	list_add_tail(&fsc->metric_wakeup, &ceph_fsc_list);
>>>>    	spin_unlock(&ceph_fsc_lock);
>>>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>>>> index 506d52633627..58bbb5df42da 100644
>>>> --- a/fs/ceph/super.h
>>>> +++ b/fs/ceph/super.h
>>>> @@ -19,6 +19,7 @@
>>>>    #include <linux/security.h>
>>>>    #include <linux/netfs.h>
>>>>    #include <linux/fscache.h>
>>>> +#include <linux/hashtable.h>
>>>>    
>>>>    #include <linux/ceph/libceph.h>
>>>>    
>>>> @@ -99,6 +100,8 @@ struct ceph_mount_options {
>>>>    	char *mon_addr;
>>>>    };
>>>>    
>>>> +#define CEPH_ASYNC_CREATE_CONFLICT_BITS 12
>>>> +
>>>>    struct ceph_fs_client {
>>>>    	struct super_block *sb;
>>>>    
>>>> @@ -124,6 +127,8 @@ struct ceph_fs_client {
>>>>    	struct workqueue_struct *inode_wq;
>>>>    	struct workqueue_struct *cap_wq;
>>>>    
>>>> +	DECLARE_HASHTABLE(async_unlink_conflict, CEPH_ASYNC_CREATE_CONFLICT_BITS);
>>>> +
>>>>    #ifdef CONFIG_DEBUG_FS
>>>>    	struct dentry *debugfs_dentry_lru, *debugfs_caps;
>>>>    	struct dentry *debugfs_congestion_kb;
>>>> @@ -281,7 +286,8 @@ struct ceph_dentry_info {
>>>>    	struct dentry *dentry;
>>>>    	struct ceph_mds_session *lease_session;
>>>>    	struct list_head lease_list;
>>>> -	unsigned flags;
>>>> +	struct hlist_node hnode;
>>>> +	unsigned long flags;
>>>>    	int lease_shared_gen;
>>>>    	u32 lease_gen;
>>>>    	u32 lease_seq;
>>>> @@ -290,10 +296,12 @@ struct ceph_dentry_info {
>>>>    	u64 offset;
>>>>    };
>>>>    
>>>> -#define CEPH_DENTRY_REFERENCED		1
>>>> -#define CEPH_DENTRY_LEASE_LIST		2
>>>> -#define CEPH_DENTRY_SHRINK_LIST		4
>>>> -#define CEPH_DENTRY_PRIMARY_LINK	8
>>>> +#define CEPH_DENTRY_REFERENCED		(1 << 0)
>>>> +#define CEPH_DENTRY_LEASE_LIST		(1 << 1)
>>>> +#define CEPH_DENTRY_SHRINK_LIST		(1 << 2)
>>>> +#define CEPH_DENTRY_PRIMARY_LINK	(1 << 3)
>>>> +#define CEPH_DENTRY_ASYNC_UNLINK_BIT	(4)
>>>> +#define CEPH_DENTRY_ASYNC_UNLINK	(1 << CEPH_DENTRY_ASYNC_UNLINK_BIT)
>>>>    
>>>>    struct ceph_inode_xattrs_info {
>>>>    	/*

