Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47A152BE2B
	for <lists+ceph-devel@lfdr.de>; Wed, 18 May 2022 17:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238778AbiEROnr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 18 May 2022 10:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238718AbiEROno (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 18 May 2022 10:43:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C451D1D4A33
        for <ceph-devel@vger.kernel.org>; Wed, 18 May 2022 07:43:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77BEE6194B
        for <ceph-devel@vger.kernel.org>; Wed, 18 May 2022 14:43:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556D8C385A9;
        Wed, 18 May 2022 14:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652885021;
        bh=u/fGhUGJLd2bgRPJte6MABfrvxwuWB0NMwYmYzkIz4Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=AY3bzJhncRvpheYbLWosBsoRp6d5HWqR0cJg/nc4m/MKBeY+1++LAo2F0QLiPRpsd
         MkoRMpZkNzA24XAmdvwzs4zS+9Ke1tF15/IY3bs4N8capezbKLNjFVyY9q/vmCe05e
         2tlX6wjTZoxNOfrMxdnlmeqa8Juxm03IGnM7kVz6T6cUPHdK7nIH9r8ARccOhbq5mj
         e7io6gyGusrZoXQwiyr/3W8MR99J1+nt+H2R+83il9AKEfWPnsYwHr4I9OiUPyBswH
         rVn5jHtXiT3Yv1h/SoHXFWzAmc2f7deJpZimZyzSXa8x9yRoCiNKUVcQHt5CflvrSl
         atSkZe4bhOxzw==
Message-ID: <7ddd67b2006057ce1a768dd77954725deca0db22.camel@kernel.org>
Subject: Re: [PATCH] ceph: switch TASK_INTERRUPTIBLE to TASK_KILLABLE
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com
Cc:     vshankar@redhat.com, ceph-devel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>
Date:   Wed, 18 May 2022 10:43:40 -0400
In-Reply-To: <20220518144122.231243-1-xiubli@redhat.com>
References: <20220518144122.231243-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-05-18 at 22:41 +0800, Xiubo Li wrote:
> If the task is placed in the TASK_INTERRUPTIBLE state it will sleep
> until either something explicitly wakes it up, or a non-masked signal
> is received. Switch to TASK_KILLABLE to avoid the noises.
>=20
> Cc: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index d1ae679c52c3..f72f40b3e26b 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -579,7 +579,7 @@ static inline int ceph_wait_on_async_create(struct in=
ode *inode)
>  	struct ceph_inode_info *ci =3D ceph_inode(inode);
> =20
>  	return wait_on_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT,
> -			   TASK_INTERRUPTIBLE);
> +			   TASK_KILLABLE);
>  }
> =20
>  extern int ceph_wait_on_conflict_unlink(struct dentry *dentry);

Reviewed-by: Jeff Layton <jlayton@kernel.org>
