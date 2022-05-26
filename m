Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C9A534D7C
	for <lists+ceph-devel@lfdr.de>; Thu, 26 May 2022 12:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbiEZKhe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 May 2022 06:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbiEZKhd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 May 2022 06:37:33 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95E7BAB
        for <ceph-devel@vger.kernel.org>; Thu, 26 May 2022 03:37:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 690AACE2012
        for <ceph-devel@vger.kernel.org>; Thu, 26 May 2022 10:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C1BC385A9;
        Thu, 26 May 2022 10:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653561446;
        bh=PNecmTieQuU01NYhq8VoouYCwjKw2lpUSHzHSpUo6nY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Cdmtdxq6LIfowE9B4qJsTaSePMwq+shESfzQUx13WSOlT3Ak62SJKI3VkbOGcbZt0
         BU6TgSrA0jUb8qX/uC9a9fM1qxL4M8loj2YPu8OpRk77v3p3FBUj2v1owEayIBX2b4
         AkDhNdAt2p0RLERTTH7RGKNBOdCJ4eUWzI7sqacb3ToUYqJmrDhzhh1uDmwvn0Ejnh
         +sAh53f060JQmrcsj78PsC81sWHKXQe0K9ez50yxN6qk6QoXG+XnYfqtESiRraYD3g
         uuGk+YylnLEEhmK9DeJXyqHRg3jvREoPml7xoojKEq/q14XvXFs95WFJEy8e9erpBQ
         jtArLEg2pgrFQ==
Message-ID: <afb34ae5b243ccea7e799b45812c47ad6efa0541.camel@kernel.org>
Subject: Re: [PATCH] ceph: remove useless CEPHFS_FEATURES_CLIENT_REQUIRED
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com
Cc:     lhenriques@suse.de, vshankar@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 26 May 2022 06:37:24 -0400
In-Reply-To: <20220526060721.735547-1-xiubli@redhat.com>
References: <20220526060721.735547-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-05-26 at 14:07 +0800, Xiubo Li wrote:
> This macro was added but never be used. And check the ceph code
> there has another CEPHFS_FEATURES_MDS_REQUIRED but always be empty.
>=20
> We should clean up all this related code, which make no sense but
> introducing confusion.
>=20
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.h | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 636fcf4503e0..d8ec2ac93da3 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -42,7 +42,6 @@ enum ceph_feature_type {
>  	CEPHFS_FEATURE_DELEG_INO,		\
>  	CEPHFS_FEATURE_METRIC_COLLECT,		\
>  }
> -#define CEPHFS_FEATURES_CLIENT_REQUIRED {}
> =20
>  /*
>   * Some lock dependencies:

Reviewed-by: Jeff Layton <jlayton@kernel.org>
