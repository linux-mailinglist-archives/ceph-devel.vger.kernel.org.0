Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C4775ABE0
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Jul 2023 12:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjGTKZL (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Jul 2023 06:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjGTKZK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Jul 2023 06:25:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78C310D4;
        Thu, 20 Jul 2023 03:25:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BB8A61943;
        Thu, 20 Jul 2023 10:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82ECC433C7;
        Thu, 20 Jul 2023 10:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689848708;
        bh=k8LUVsSWJYD2I9NRsqKLB26TXdfvdNl+zpbMvFYyymc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Z2R14fb5oUAGWnVU+D+VUOkywZF9RRIFTPf6Gy1HCUCsNM9G6tZKFS+HBCu5EVLPz
         vWc3QUO+N3IV5fKfnF68Ckp9FzWbKrpxwhsURS56cirRK6AtiRo3vfwTC8hPzx0rv7
         qxoLhJf1ZT7I7AxRHbKHx5bFF9hTbbpqONyB3aHg4Pj5SBq4Bg0xMKiF3yGWd2zzWx
         oWdNIgqJ4uvMpFVJwVNBDd8mpl1YACNoIcmqzTgnMbp2GumyzJWY/BLVdytiVw7jeJ
         TXv9Z5u7S51F1PYaBUArIptIJUoBQEsKlMDr2pmGTv1Ppoi/eoVXVZV+6hvWpx/7zf
         ZupIe94IGmxFw==
Message-ID: <e5d64fae9611808c77b4e1d23a25ae643fa50177.camel@kernel.org>
Subject: Re: [PATCH] ceph: disable sending metrics thoroughly when it's
 disabled
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     vshankar@redhat.com, mchangir@redhat.com, stable@vger.kernel.org
Date:   Thu, 20 Jul 2023 06:25:06 -0400
In-Reply-To: <20230720033800.110717-1-xiubli@redhat.com>
References: <20230720033800.110717-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2023-07-20 at 11:38 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>=20
> Even the 'disable_send_metrics' is true so when the session is
> being opened it will always trigger to send the metric for the
> first time.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/metric.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
> index cce78d769f55..6d3584f16f9a 100644
> --- a/fs/ceph/metric.c
> +++ b/fs/ceph/metric.c
> @@ -216,7 +216,7 @@ static void metric_delayed_work(struct work_struct *w=
ork)
>  	struct ceph_mds_client *mdsc =3D
>  		container_of(m, struct ceph_mds_client, metric);
> =20
> -	if (mdsc->stopping)
> +	if (mdsc->stopping || disable_send_metrics)
>  		return;
> =20
>  	if (!m->session || !check_session_state(m->session)) {

Reviewed-by: Jeff Layton <jlayton@kernel.org>
