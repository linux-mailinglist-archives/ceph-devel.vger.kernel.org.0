Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89D5148471A
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jan 2022 18:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235747AbiADRkz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jan 2022 12:40:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59472 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234307AbiADRkz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jan 2022 12:40:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19B17B817A1
        for <ceph-devel@vger.kernel.org>; Tue,  4 Jan 2022 17:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51593C36AE9;
        Tue,  4 Jan 2022 17:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641318052;
        bh=BbhURt+aI0rMV8lmm4SFAUE89Lb1Wq3qWePdIm+B1zw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OJw4hhvS2+emXAQcy7F8HwFi1w9ZE5dlS5idu41woZdU+f/gk2gPe4kP/g8kCMYzP
         +h3Lx4FD+aHvdmDDjtGayO6kfrnpnoeFNVs+RfyAPTG99z5pYhkwwmthTZiVfEntgB
         APFk0vFrye2n3IzFBWLivBW+KKdUX/bAIApj0c8NorjDSuvsviZxJVDiC7ZbkQAer3
         oIYSmjwe5lF/2zDeDsG/BsmMQdNcospSBLpqdQol/Ri53t44aTD2y6IzaUOydlszsi
         t6mBJGykDFQkTr5X/HYK0cfJs2h//khhmqhQGmgFDxPTlUFiAVC0b44zTS/d6AqObN
         odgOiRZy4TS9g==
Message-ID: <cdd3f83fd64cc308a7694875c1e4a35f0d052429.camel@kernel.org>
Subject: Re: [PATCH 02/12] ceph: handle idmapped mounts in
 create_request_message()
From:   Jeff Layton <jlayton@kernel.org>
To:     Christian Brauner <brauner@kernel.org>, ceph-devel@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Christian Brauner <christian.brauner@ubuntu.com>
Date:   Tue, 04 Jan 2022 12:40:51 -0500
In-Reply-To: <20220104140414.155198-3-brauner@kernel.org>
References: <20220104140414.155198-1-brauner@kernel.org>
         <20220104140414.155198-3-brauner@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-01-04 at 15:04 +0100, Christian Brauner wrote:
> From: Christian Brauner <christian.brauner@ubuntu.com>
> 
> Inode operations that create a new filesystem object such as ->mknod,
> ->create, ->mkdir() and others don't take a {g,u}id argument explicitly.
> Instead the caller's fs{g,u}id is used for the {g,u}id of the new
> filesystem object.
> 
> Cephfs mds creation request argument structures mirror this filesystem
> behavior. They don't encode a {g,u}id explicitly. Instead the caller's
> fs{g,u}id that is always sent as part of any mds request is used by the
> servers to set the {g,u}id of the new filesystem object.
> 
> In order to ensure that the correct {g,u}id is used map the caller's
> fs{g,u}id for creation requests. This doesn't require complex changes.
> It suffices to pass in the relevant idmapping recorded in the request
> message. If this request message was triggered from an inode operation
> that creates filesystem objects it will have passed down the relevant
> idmaping. If this is a request message that was triggered from an inode
> operation that doens't need to take idmappings into account the initial
> idmapping is passed down which is an identity mapping and thus is
> guaranteed to leave the caller's fs{g,u}id unchanged.,u}id is sent.
> 
> The last few weeks before Christmas 2021 I have spent time not just
> reading and poking the cephfs kernel code but also took a look at the
> ceph mds server userspace to ensure I didn't miss some subtlety.
> 
> This made me aware of one complication to solve. All requests send the
> caller's fs{g,u}id over the wire. The caller's fs{g,u}id matters for the
> server in exactly two cases:
> 
> 1. to set the ownership for creation requests
> 2. to determine whether this client is allowed access on this server
> 
> Case 1. we already covered and explained. Case 2. is only relevant for
> servers where an explicit uid access restriction has been set. That is
> to say the mds server restricts access to requests coming from a
> specific uid. Servers without uid restrictions will grant access to
> requests from any uid by setting MDS_AUTH_UID_ANY.
> 
> Case 2. introduces the complication because the caller's fs{g,u}id is
> not just used to record ownership but also serves as the {g,u}id used
> when checking access to the server.
> 
> Consider a user mounting a cephfs client and creating an idmapped mount
> from it that maps files owned by uid 1000 to be owned uid 0:
> 
> mount -t cephfs -o [...] /unmapped
> mount-idmapped --map-mount 1000:0:1 /idmapped
> 
> That is to say if the mounted cephfs filesystem contains a file "file1"
> which is owned by uid 1000:
> 
> - looking at it via /unmapped/file1 will report it as owned by uid 1000
>   (One can think of this as the on-disk value.)
> - looking at it via /idmapped/file1 will report it as owned by uid 0
> 
> Now, consider creating new files via the idmapped mount at /idmapped.
> When a caller with fs{g,u}id 1000 creates a file "file2" by going
> through the idmapped mount mounted at /idmapped it will create a file
> that is owned by uid 1000 on-disk, i.e.:
> 
> - looking at it via /unmapped/file2 will report it as owned by uid 1000
> - looking at it via /idmapped/file2 will report it as owned by uid 0
> 
> Now consider an mds server that has a uid access restriction set and
> only grants access to requests from uid 0.
> 
> If the client sends a creation request for a file e.g. /idmapped/file2
> it will send the caller's fs{g,u}id idmapped according to the idmapped
> mount. So if the caller has fs{g,u}id 1000 it will be mapped to {g,u}id
> 0 in the idmapped mount and will be sent over the wire allowing the
> caller access to the mds server.
> 
> However, if the caller is not issuing a creation request the caller's
> fs{g,u}id will be send without the mount's idmapping applied. So if the
> caller that just successfully created a new file on the restricted mds
> server sends a request as fs{g,u}id 1000 access will be refused. This
> however is inconsistent.
> 

IDGI, why would you send the fs{g,u}id without the mount's idmapping
applied in this case? ISTM that idmapping is wholly a client-side
feature, and that you should always map id's regardless of whether
you're creating or not.

> From my perspective the root of the problem lies in the fact that
> creation requests implicitly infer the ownership from the {g,u}id that
> gets sent along with every mds request.
> 
> I have thought of multiple ways of addressing this problem but the one I
> prefer is to give all mds requests that create a filesystem object a
> proper, separate {g,u}id field entry in the argument struct. This is,
> for example how ->setattr mds requests work.
> 
> This way the caller's fs{g,u}id can be used consistenly for server
> access checks and is separated from the ownership for new filesystem
> objects.
> 
> Servers could then be updated to refuse creation requests whenever the
> {g,u}id used for access checking doesn't match the {g,u}id used for
> creating the filesystem object just as is done for setattr requests on a
> uid restricted server. But I am, of course, open to other suggestions.
> 
> Cc: Jeff Layton <jlayton@kernel.org>
> Cc: Ilya Dryomov <idryomov@gmail.com>
> Cc: ceph-devel@vger.kernel.org
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> ---
>  fs/ceph/mds_client.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index ae2cc4ce1d48..1fb43a8fd64c 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2459,6 +2459,8 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
>  	void *p, *end;
>  	int ret;
>  	bool legacy = !(session->s_con.peer_features & CEPH_FEATURE_FS_BTIME);
> +	kuid_t caller_fsuid;
> +	kgid_t caller_fsgid;
>  
>  	ret = set_request_path_attr(req->r_inode, req->r_dentry,
>  			      req->r_parent, req->r_path1, req->r_ino1.ino,
> @@ -2524,10 +2526,22 @@ static struct ceph_msg *create_request_message(struct ceph_mds_session *session,
>  
>  	head->mdsmap_epoch = cpu_to_le32(mdsc->mdsmap->m_epoch);
>  	head->op = cpu_to_le32(req->r_op);
> -	head->caller_uid = cpu_to_le32(from_kuid(&init_user_ns,
> -						 req->r_cred->fsuid));
> -	head->caller_gid = cpu_to_le32(from_kgid(&init_user_ns,
> -						 req->r_cred->fsgid));
> +	/*
> +	 * Inode operations that create filesystem objects based on the
> +	 * caller's fs{g,u}id like ->mknod(), ->create(), ->mkdir() etc. don't
> +	 * have separate {g,u}id fields in their respective structs in the
> +	 * ceph_mds_request_args union. Instead the caller_{g,u}id field is
> +	 * used to set ownership of the newly created inode by the mds server.
> +	 * For these inode operations we need to send the mapped fs{g,u}id over
> +	 * the wire. For other cases we simple set req->mnt_userns to the
> +	 * initial idmapping meaning the unmapped fs{g,u}id is sent.
> +	 */
> +	caller_fsuid = mapped_kuid_user(req->mnt_userns, &init_user_ns,
> +					req->r_cred->fsuid);
> +	caller_fsgid = mapped_kgid_user(req->mnt_userns, &init_user_ns,
> +					req->r_cred->fsgid);
> +	head->caller_uid = cpu_to_le32(from_kuid(&init_user_ns, caller_fsuid));
> +	head->caller_gid = cpu_to_le32(from_kgid(&init_user_ns, caller_fsgid));
>  	head->ino = cpu_to_le64(req->r_deleg_ino);
>  	head->args = req->r_args;
>  

-- 
Jeff Layton <jlayton@kernel.org>
