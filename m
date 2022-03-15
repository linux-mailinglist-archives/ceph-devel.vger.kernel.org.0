Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757374D9B68
	for <lists+ceph-devel@lfdr.de>; Tue, 15 Mar 2022 13:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238875AbiCOMm3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 15 Mar 2022 08:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235627AbiCOMm1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 15 Mar 2022 08:42:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BFFC31207
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 05:41:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B447061525
        for <ceph-devel@vger.kernel.org>; Tue, 15 Mar 2022 12:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96100C340E8;
        Tue, 15 Mar 2022 12:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647348075;
        bh=fUiZVnJLIe0aBP3NjnReM590r6caten3S0nsPmOlem0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PT4jbAtqPMljFIVXlHf/q8VkltiNfVqDQMnH9QSNsXGB0aKv5eabaJ/k6Orgyy59V
         fQ+LC3B/x6JE6eV8i5p0625JtOSQsNqoGE1LvYdTQtTKMIU8ELn0Vlnva4EmaNNCYF
         Bq7z7LJWCc7yy2OOnRF4Ml4RWij9XBAdiTuhJk36L5YtjjJWxQbDd0gmn6Q6iuI/90
         xqLnf/EpYkZYXGR6/jE35lyS9Z1dO+eb6d08z1cV3aebCoIhj/+fwVXjyhjHiDqHeB
         KZtJU3gyETaiPCuqmJIu4oslm6G26GU2mvzeALN5FqlsbBFyqfzaTliqP982aPOqEJ
         TTmB2pm7ZivUA==
Message-ID: <db065a435d712ca9ec9245bdad3f43dc8e271385.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: send the fscrypt_auth to MDS via request
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
Date:   Tue, 15 Mar 2022 08:41:13 -0400
In-Reply-To: <20220315093741.25664-1-xiubli@redhat.com>
References: <20220315093741.25664-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-03-15 at 17:37 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Currently when creating new files or directories the kclient will
> create a new inode and fill the fscrypt auth locally, without sending
> it to MDS via requests. Then the MDS reply with it to empty too.
> And the kclient will update it later together with the cap update
> requests.
> 
> It's buggy if just after the create requests succeeds but the kclient
> crash and reboot, then in MDS side the fscrypt_auth will keep empty.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> V2:
> - Fix the compile errors without CONFIG_FS_ENCRYPTION enabled.
> 
> 
> 
>  fs/ceph/dir.c  | 43 +++++++++++++++++++++++++++++++++++++++++--
>  fs/ceph/file.c | 17 ++++++++++++++++-
>  2 files changed, 57 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 5ae5cb778389..8675898a4336 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -904,8 +904,22 @@ static int ceph_mknod(struct user_namespace *mnt_userns, struct inode *dir,
>  		goto out_req;
>  	}
>  
> -	if (S_ISREG(mode) && IS_ENCRYPTED(dir))
> -		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
> +	if (IS_ENCRYPTED(dir)) {
> +#ifdef CONFIG_FS_ENCRYPTION
> +		struct ceph_inode_info *ci = ceph_inode(req->r_new_inode);
> +
> +		req->r_fscrypt_auth = kmemdup(ci->fscrypt_auth,
> +					      ci->fscrypt_auth_len,
> +					      GFP_KERNEL);
> +		if (!req->r_fscrypt_auth) {
> +			err = -ENOMEM;
> +			goto out_req;
> +		}
> +#endif

I thought ceph_as_ctx_to_req was supposed to populate this field. If
that's not happening here then there is a bug in that codepath, and we
should just fix that instead of doing a workaround like this.

> +
> +		if (S_ISREG(mode))
> +			set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
> +	}
>  
>  	req->r_dentry = dget(dentry);
>  	req->r_num_caps = 2;
> @@ -1008,6 +1022,18 @@ static int ceph_symlink(struct user_namespace *mnt_userns, struct inode *dir,
>  	ihold(dir);
>  
>  	if (IS_ENCRYPTED(req->r_new_inode)) {
> +#ifdef CONFIG_FS_ENCRYPTION
> +		struct ceph_inode_info *ci = ceph_inode(req->r_new_inode);
> +
> +		req->r_fscrypt_auth = kmemdup(ci->fscrypt_auth,
> +					      ci->fscrypt_auth_len,
> +					      GFP_KERNEL);
> +		if (!req->r_fscrypt_auth) {
> +			err = -ENOMEM;
> +			goto out_req;
> +		}
> +#endif
> +
>  		err = prep_encrypted_symlink_target(req, dest);
>  		if (err)
>  			goto out_req;
> @@ -1081,6 +1107,19 @@ static int ceph_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
>  		goto out_req;
>  	}
>  
> +#ifdef CONFIG_FS_ENCRYPTION
> +	if (IS_ENCRYPTED(dir)) {
> +		struct ceph_inode_info *ci = ceph_inode(req->r_new_inode);
> +
> +		req->r_fscrypt_auth = kmemdup(ci->fscrypt_auth,
> +					      ci->fscrypt_auth_len,
> +					      GFP_KERNEL);
> +		if (!req->r_fscrypt_auth) {
> +			err = -ENOMEM;
> +			goto out_req;
> +		}
> +	}
> +#endif
>  	req->r_dentry = dget(dentry);
>  	req->r_num_caps = 2;
>  	req->r_parent = dir;
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 61ffbda5b934..70ac41d6e0d4 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -771,9 +771,24 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>  	req->r_args.open.mask = cpu_to_le32(mask);
>  	req->r_parent = dir;
>  	ihold(dir);
> -	if (IS_ENCRYPTED(dir))
> +	if (IS_ENCRYPTED(dir)) {
>  		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
>  
> +#ifdef CONFIG_FS_ENCRYPTION
> +		if (new_inode) {
> +			struct ceph_inode_info *ci = ceph_inode(new_inode);
> +
> +			req->r_fscrypt_auth = kmemdup(ci->fscrypt_auth,
> +						      ci->fscrypt_auth_len,
> +						      GFP_KERNEL);
> +			if (!req->r_fscrypt_auth) {
> +				err = -ENOMEM;
> +				goto out_req;
> +			}
> +		}
> +#endif
> +	}
> +
>  	if (flags & O_CREAT) {
>  		struct ceph_file_layout lo;
>  

-- 
Jeff Layton <jlayton@kernel.org>
