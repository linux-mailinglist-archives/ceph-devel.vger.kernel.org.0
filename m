Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F644C3DF0
	for <lists+ceph-devel@lfdr.de>; Fri, 25 Feb 2022 06:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237567AbiBYFhL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 25 Feb 2022 00:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237261AbiBYFhK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 25 Feb 2022 00:37:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3CFE027B29
        for <ceph-devel@vger.kernel.org>; Thu, 24 Feb 2022 21:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645767394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/EmBOuIHlG591wLcgnhpf7mq1SLYtaesSG4JYPO3Ae4=;
        b=QPSUZ9iVfS68lqtMpbX+jS7c2Bnux5thcdaH1nsixJC4AKgJ9dwZ8TwaDBQdbqDGkro2/p
        hPPzbswDkYl3TadYBASVPxhbxnY9r565pogGeuU6ETPmAwB8qOQtjLUS31h2G0fQJPeyj7
        EiIrtXEQ9SxwGeP4NKa1q2xxIF2c1i8=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-XIE10A77PJu7vckrVDdv6Q-1; Fri, 25 Feb 2022 00:36:32 -0500
X-MC-Unique: XIE10A77PJu7vckrVDdv6Q-1
Received: by mail-pl1-f198.google.com with SMTP id l6-20020a170903120600b0014f43ba55f3so2420419plh.11
        for <ceph-devel@vger.kernel.org>; Thu, 24 Feb 2022 21:36:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/EmBOuIHlG591wLcgnhpf7mq1SLYtaesSG4JYPO3Ae4=;
        b=oQe1b3eBM4Fe9IE6Py1T6kKLQtTmEHTJ8VSgL+oHkR7aTCfD/nVzrsz5w5iFyEfSmp
         jrSPK43QSvRQ5ydc7LKzM3VY77UWlU6s2JSbVNc+zHdEFsgiQbrU4fB5A3cJHuIuKedn
         3OcLUb40hH+VdTs5ULjlB54R17zM9X+O2p4dD8ZOuFzQsju6pR+JRpbdSpJzrMVAs+2f
         40N8g8FW34LpTNZzbg9sFPf8pds9jCHOtc09nA9gC644G2/gmkaIqAWqnYZ9UEncUHV0
         9TxrhEQ4UiI6+TMS6T7RfWAfh6cxlBVulN1nyGZdNEdJ4FoUU52Y0Z/vMPRfxoIqx8XG
         5kyw==
X-Gm-Message-State: AOAM5327oC5qpUGa3sDzq757bLQvCgAwL/K9zoXrQakhPynODoA/3D3F
        AONkjfME/uYTxGoHgwNxFhJvAd0z6Kr3Ap3+AoSUsPWl8/h/JMRa6QPJn5jDCyFBvwacbW0cj/R
        vI5x8DNF5EzpLu5LXaVrmAg==
X-Received: by 2002:a17:902:f70d:b0:14f:a1e1:b9b3 with SMTP id h13-20020a170902f70d00b0014fa1e1b9b3mr5870752plo.36.1645767391208;
        Thu, 24 Feb 2022 21:36:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwiiXsd4xahPwiW6r0AIofmiUU0MlMH3nliR/roKSNeVm9RBYdvRY2BJ9FFuPjqkgJwyFWaPw==
X-Received: by 2002:a17:902:f70d:b0:14f:a1e1:b9b3 with SMTP id h13-20020a170902f70d00b0014fa1e1b9b3mr5870730plo.36.1645767390901;
        Thu, 24 Feb 2022 21:36:30 -0800 (PST)
Received: from [10.72.12.114] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u37-20020a056a0009a500b004e1414d69besm1398278pfg.151.2022.02.24.21.36.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Feb 2022 21:36:30 -0800 (PST)
Subject: Re: [RFC PATCH] ceph: add support for encrypted snapshot names
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220224112142.18052-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <27801620-b3fd-d556-c100-409632f91661@redhat.com>
Date:   Fri, 25 Feb 2022 13:36:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220224112142.18052-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 2/24/22 7:21 PM, Luís Henriques wrote:
> Since filenames in encrypted directories are already encrypted and shown
> as a base64-encoded string when the directory is locked, snapshot names
> should show a similar behaviour.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>   fs/ceph/dir.c   | 15 +++++++++++++++
>   fs/ceph/inode.c | 10 +++++++++-
>   2 files changed, 24 insertions(+), 1 deletion(-)
>
> Support on the MDS for names that'll be > MAX_NAME when base64 encoded is
> still TBD.  I thought it would be something easy to do, but snapshots
> don't seem to make use of the CDir/CDentry (which is where alternate_name
> is stored on the MDS).  I'm still looking into this, but I may need some
> help there :-(

Yeah, good catch. The snapshot handler in MDS hasn't handled this case 
yet, though the kclient has passed it to MDS server.

The snapshot alternate_name raw ciphertext should be stored in SnapInfo 
struct along with the 'name'.


>
> Cheers,
> --
> Luís
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index a449f4a07c07..20ae600ee7cd 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -1065,6 +1065,13 @@ static int ceph_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
>   		op = CEPH_MDS_OP_MKSNAP;
>   		dout("mksnap dir %p snap '%pd' dn %p\n", dir,
>   		     dentry, dentry);
> +		/* XXX missing support for alternate_name in snapshots */
> +		if (IS_ENCRYPTED(dir) && (dentry->d_name.len >= 189)) {
> +			dout("encrypted snapshot name too long: %pd len: %d\n",
> +			     dentry, dentry->d_name.len);
> +			err = -ENAMETOOLONG;
> +			goto out;
> +		}

We should fix the MDS side bug and then this workaroud will be no needed.

- Xiubo

>   	} else if (ceph_snap(dir) == CEPH_NOSNAP) {
>   		dout("mkdir dir %p dn %p mode 0%ho\n", dir, dentry, mode);
>   		op = CEPH_MDS_OP_MKDIR;
> @@ -1109,6 +1116,14 @@ static int ceph_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
>   	    !req->r_reply_info.head->is_target &&
>   	    !req->r_reply_info.head->is_dentry)
>   		err = ceph_handle_notrace_create(dir, dentry);
> +
> +	/*
> +	 * If we have created a snapshot we need to clear the cache, otherwise
> +	 * snapshot will show encrypted filenames in readdir.
> +	 */
> +	if (ceph_snap(dir) == CEPH_SNAPDIR)
> +		d_drop(dentry);
> +
>   out_req:
>   	ceph_mdsc_put_request(req);
>   out:
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 8b0832271fdf..080824610b73 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -182,6 +182,13 @@ struct inode *ceph_get_snapdir(struct inode *parent)
>   	ci->i_rbytes = 0;
>   	ci->i_btime = ceph_inode(parent)->i_btime;
>   
> +	/* if encrypted, just borough fscrypt_auth from parent */
> +	if (IS_ENCRYPTED(parent)) {
> +		struct ceph_inode_info *pci = ceph_inode(parent);
> +		inode->i_flags |= S_ENCRYPTED;
> +		ci->fscrypt_auth_len = pci->fscrypt_auth_len;
> +		ci->fscrypt_auth = pci->fscrypt_auth;
> +	}
>   	if (inode->i_state & I_NEW) {
>   		inode->i_op = &ceph_snapdir_iops;
>   		inode->i_fop = &ceph_snapdir_fops;
> @@ -632,7 +639,8 @@ void ceph_free_inode(struct inode *inode)
>   
>   	kfree(ci->i_symlink);
>   #ifdef CONFIG_FS_ENCRYPTION
> -	kfree(ci->fscrypt_auth);
> +	if (ceph_snap(inode) != CEPH_SNAPDIR)
> +		kfree(ci->fscrypt_auth);
>   #endif
>   	fscrypt_free_inode(inode);
>   	kmem_cache_free(ceph_inode_cachep, ci);
>

