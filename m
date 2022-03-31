Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3CF4ED978
	for <lists+ceph-devel@lfdr.de>; Thu, 31 Mar 2022 14:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234316AbiCaMRK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 31 Mar 2022 08:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235921AbiCaMRJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 31 Mar 2022 08:17:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A558A554A7
        for <ceph-devel@vger.kernel.org>; Thu, 31 Mar 2022 05:15:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 419B26179F
        for <ceph-devel@vger.kernel.org>; Thu, 31 Mar 2022 12:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBB6C340EE;
        Thu, 31 Mar 2022 12:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648728921;
        bh=FgK4LTcPqT6PCFGsgaW818Ec9Qdx7eJlHYGx3GwzVoc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GA9VofSyLyIZ+SIvVrPmHaMpDCikV7b1mQijnM2sKRMjPeaGL0plURnsjBoJoPP68
         cLqBki5Lg/AQ0zQTiZkNhCZwjA1InkpkkpArrNpAsDIspWv8vW182nnXDMSO8XL98A
         yISDIFJOXTVIxVoXSODtba5nkkC6q9KrYeO2mxay0ROypC4fK0OyX7mZ+7afgDK/EW
         /2lVDLWTks+Z1JWSWwq2feTZSgv47UK5w74oWf+cZ62qYbGcljTFQNZrnbW+FSFOhL
         vMwyY4WxmxkrrVxFoXEelK7hmqUtCdplqPPsa8n3m+1nFBewajt7x0qKUE7U7uzjey
         tGm6a2P7zOdUQ==
Message-ID: <698a6e07098eb391c1ac6cf632f4a4fd20b3bbd4.camel@kernel.org>
Subject: Re: [PATCH 1/3] ceph: add the Octopus,Pacific,Quency feature bits
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, Patrick Donnelly <pdonnell@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 31 Mar 2022 08:15:19 -0400
In-Reply-To: <20220331065241.27370-2-xiubli@redhat.com>
References: <20220331065241.27370-1-xiubli@redhat.com>
         <20220331065241.27370-2-xiubli@redhat.com>
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

On Thu, 2022-03-31 at 14:52 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> URL: https://tracker.ceph.com/issues/54411
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.h | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 33497846e47e..32107c26f50d 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -27,10 +27,13 @@ enum ceph_feature_type {
>  	CEPHFS_FEATURE_RECLAIM_CLIENT,
>  	CEPHFS_FEATURE_LAZY_CAP_WANTED,
>  	CEPHFS_FEATURE_MULTI_RECONNECT,
> -	CEPHFS_FEATURE_DELEG_INO,
> -	CEPHFS_FEATURE_METRIC_COLLECT,
> +	CEPHFS_FEATURE_OCTOPUS,
> +	CEPHFS_FEATURE_DELEG_INO = CEPHFS_FEATURE_OCTOPUS,
> +	CEPHFS_FEATURE_PACIFIC,
> +	CEPHFS_FEATURE_METRIC_COLLECT = CEPHFS_FEATURE_PACIFIC,
> +	CEPHFS_FEATURE_QUINCY,
>  
> -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_METRIC_COLLECT,
> +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_QUINCY,
>  };
>  
>  /*

(cc'ing Patrick)

I think we decided a while back to move away from "release" feature
flags like this, because they're ambiguous. We do occasionally backport
features to later stable versions and then the release flag becomes
meaningless.

If the "feature" here is extended metrics, then this should be something
like CEPHFS_FEATURE_METRIC_V2 or METRIC_EXTENDED or something. IOW, the
flag name should describe the feature that we're advertising. 
-- 
Jeff Layton <jlayton@kernel.org>
