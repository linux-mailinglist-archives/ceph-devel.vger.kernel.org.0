Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F090868D72A
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Feb 2023 13:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbjBGMsy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Feb 2023 07:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbjBGMso (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Feb 2023 07:48:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643D415565
        for <ceph-devel@vger.kernel.org>; Tue,  7 Feb 2023 04:48:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F396061378
        for <ceph-devel@vger.kernel.org>; Tue,  7 Feb 2023 12:48:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB60C433EF;
        Tue,  7 Feb 2023 12:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675774121;
        bh=Q1799rLa2BN6ev7/gHrr+ajVxlYLIw0SmtYHleapSv4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=a7izEuma3xFiDh5itSZf9MKmEhlBMP45BBIbmD6gPNdPilILVOZFnpkGhSQSUYMl0
         SKzRuR8A+PUXKq3WTGVwHvkZucVHtd48lV0UMVy64L8zXhnHzq3tPFaMH/hMLkOd4U
         cTdRrCDVnQ4roXYPdmk/2s38vrQnYgSL8jpajYfmvDzXUWCme6o6uTTWQG1vbXWUO5
         deNji07GoGHIANN0XOVSL6LMF0cH4ZagdlMM5f3V+NuS5PTEDkTQobYO0n7SndsBpV
         /dsnHROjc3yF0Aj0rP/WdO9ifnw69dmeRyXlgFp3MFNO70o7Elq9nVlsGGMXp8v+vl
         4jwcrphw5kzrg==
Message-ID: <0a0e287b1debe91b1fcc5dd46f980d20175e9903.camel@kernel.org>
Subject: Re: [PATCH] ceph: flush cap release on session flush
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     mchangir@redhat.com, vshankar@redhat.com, lhenriques@suse.de,
        stable@kernel.org, Patrick Donnelly <pdonnell@redhat.com>
Date:   Tue, 07 Feb 2023 07:48:39 -0500
In-Reply-To: <20230207050452.403436-1-xiubli@redhat.com>
References: <20230207050452.403436-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2023-02-07 at 13:04 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>=20
> MDS expects the completed cap release prior to responding to the
> session flush for cache drop.
>=20
> Cc: <stable@kernel.org>
> URL: http://tracker.ceph.com/issues/38009
> Cc: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 3c9d3f609e7f..51366bd053de 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -4039,6 +4039,12 @@ static void handle_session(struct ceph_mds_session=
 *session,
>  		break;
> =20
>  	case CEPH_SESSION_FLUSHMSG:
> +		/* flush cap release */
> +		spin_lock(&session->s_cap_lock);
> +		if (session->s_num_cap_releases)
> +			ceph_flush_cap_releases(mdsc, session);
> +		spin_unlock(&session->s_cap_lock);
> +
>  		send_flushmsg_ack(mdsc, session, seq);
>  		break;
> =20

Ouch! Good catch!

Reviewed-by: Jeff Layton <jlayton@kernel.org>
