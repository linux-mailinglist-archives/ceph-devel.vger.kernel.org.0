Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394064EBEF5
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Mar 2022 12:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245458AbiC3KlR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 30 Mar 2022 06:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236321AbiC3KlQ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 30 Mar 2022 06:41:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B38D269363
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 03:39:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 66E73CE1A57
        for <ceph-devel@vger.kernel.org>; Wed, 30 Mar 2022 10:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6221BC340EC;
        Wed, 30 Mar 2022 10:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648636766;
        bh=6VnelDwSkwo2hZVoiLTF91XAffkkmAHLnxFZ6eOO/EA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=E6zYqwlyfdae8P+bryuDPCzR7YqExJSEhXuZDVoRbNXl2Fh5m0pjfC/nKj0BHuS7y
         R2jpOQb4v+x/TGPeqq4m2HbG+pqS8vqpCnfSkSCuRKQ+IfDDZtLbLcC277y4jMeSfT
         XUG8SiutRSi9itCRQep/Fv8uXpeC9ogEmhjD4CBL9umukpHZCQosQNpvPe+Hq2XESD
         JvnrJ8O6FAVKrHd/l0EOI900flT5lKXIVbNQ6X86aBrSq3IzEb7ppwK6em7wLtqddH
         WAkcZparqVcSsF7eKGYz7VXlaKtXWe16WDhRB4I9bc7XjNxXYFwBhZjmOU/M8NE1FO
         AO5TykcCzpXAg==
Message-ID: <6046490a385d690326efe4c3a3396bfdf2fed4c9.camel@kernel.org>
Subject: Re: [PATCH] ceph: update the dlease for the hashed dentry when
 removing
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Wed, 30 Mar 2022 06:39:24 -0400
In-Reply-To: <20220330054956.271022-1-xiubli@redhat.com>
References: <20220330054956.271022-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2022-03-30 at 13:49 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The MDS will always refresh the dentry lease when removing the files
> or directories. And if the dentry is still hashed, we can update
> the dentry lease and no need to do the lookup from the MDS later.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/inode.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 64b341f5e7bc..8cf55e6e609e 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1467,10 +1467,12 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
>  			} else if (have_lease) {
>  				if (d_unhashed(dn))
>  					d_add(dn, NULL);
> +			}
> +
> +			if (!d_unhashed(dn) && have_lease)
>  				update_dentry_lease(dir, dn,
>  						    rinfo->dlease, session,
>  						    req->r_request_started);
> -			}
>  			goto done;
>  		}
>  

I think this makes sense, since we can have a lease for a negative
dentry.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
