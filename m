Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053FC722832
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jun 2023 16:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbjFEOHJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Jun 2023 10:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232874AbjFEOHH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Jun 2023 10:07:07 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1A2E8
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 07:06:54 -0700 (PDT)
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id E5A0A3F592
        for <ceph-devel@vger.kernel.org>; Mon,  5 Jun 2023 14:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1685974012;
        bh=m00S/6avnRtLOYXgg+cBIVoViQC54EeAvPZld6Eonok=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=Dr4L/9vXh5v7FoOG3NaQRzcKUyIxPJ6sbTM5Nax1Tl++8iEbGyp+G2bKQGeDzZL/f
         BGfrAq/917HF8nlQe2C4jz0BoCHK4qxR//Kzn7nj3DSOiBzlEfTjyAV2dN6b6OeFOu
         GriWv2YB+8tue0JCrjtL4feYPZQz2kvSquj3h1zYb0bEUtn1QkAD5IiRaC9tabdepl
         VpdISgqAjThwEb9lJoZXx5WVhNq7ewbcDmaQkVvBd+3oX/A+8Cty521vLOHHKmCKEv
         5/6/gYAxbaDrVIXcnlJjb9D4hElnpf5535U/6bxVQAHtGHJiAqZCZqDVLgfMGv9x3y
         2GQFx/GRJ0hnw==
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-568ae92e492so81733567b3.3
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jun 2023 07:06:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685974012; x=1688566012;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m00S/6avnRtLOYXgg+cBIVoViQC54EeAvPZld6Eonok=;
        b=YKEH84ymJA5yEYWXkUMcrnZCx/DFzoMELHxELCuyiZwIYIxisIbDleUW6PSF+B/cy+
         FIFdragwh983ChSMOz9knWnFwlQaYmV5CrC9Q6g+OOExWI1UvDYNZdjTV7puFyP90orS
         vSxJdY7MVAybPVAkSfrnBYIfZZbm8WwgPGws3cRUzvpAtVKVs+POFemiRRp5B7+1T663
         F0r8iQwYOZRR+3r7ZMan2f+R7C2rI1d5HZwpp3PFAUK3c6RFdJRW+ckK/Q2xkUNjFGhG
         QYoeFOSn5E/Z0IMJZ/ksnOTR/BEaLTWz1B8iay9bumJZkVhn324Pg+bOxjew0IOHJNZu
         oe2w==
X-Gm-Message-State: AC+VfDyauzhO6FjDkX7T1V7iSamIY3DoN+A/gCKgnYiBQfWcCQeha2i6
        RuE6RmGRVoaiuGILu/VyOfYRsFeaqCaHvWotEv4E6wU7XHLa/T6dkimitYVlzO1W5XkmU/MqssW
        J+1OBZDOlxAHDasOqrCQ6PzANThRnciTGB7cargMf63hNzi/7PL2ijhY=
X-Received: by 2002:a25:7242:0:b0:ba6:be9b:3085 with SMTP id n63-20020a257242000000b00ba6be9b3085mr14652185ybc.26.1685974011989;
        Mon, 05 Jun 2023 07:06:51 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Y71T2R1g//M4TksmRejWnYl1VrxRcbq1BIOpWXIcVuvzKhSo/6+KX2iLclMGmBwIxnWndpIVceJtiYf5V1hA=
X-Received: by 2002:a25:7242:0:b0:ba6:be9b:3085 with SMTP id
 n63-20020a257242000000b00ba6be9b3085mr14652164ybc.26.1685974011736; Mon, 05
 Jun 2023 07:06:51 -0700 (PDT)
MIME-Version: 1.0
References: <20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com>
 <20230524153316.476973-2-aleksandr.mikhalitsyn@canonical.com>
 <20230602-lernprogramm-destillation-2438cc92fee3@brauner> <ZH3o4BtG6ufXUnt1@infradead.org>
In-Reply-To: <ZH3o4BtG6ufXUnt1@infradead.org>
From:   Aleksandr Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Mon, 5 Jun 2023 16:06:40 +0200
Message-ID: <CAEivzxfxjWnzuVjp_Ow_ewC_MbK=wkOGbLhCbJf=GExAs2h+_w@mail.gmail.com>
Subject: Re: [PATCH v2 01/13] fs: export mnt_idmap_get/mnt_idmap_put
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Christian Brauner <brauner@kernel.org>, xiubli@redhat.com,
        stgraber@ubuntu.com, linux-fsdevel@vger.kernel.org,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Seth Forshee <sforshee@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 5, 2023 at 3:53=E2=80=AFPM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> On Fri, Jun 02, 2023 at 02:40:27PM +0200, Christian Brauner wrote:
> > On Wed, May 24, 2023 at 05:33:03PM +0200, Alexander Mikhalitsyn wrote:
> > > These helpers are required to support idmapped mounts in the Cephfs.
> > >
> > > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical=
.com>
> > > ---
> >
> > It's fine by me to export them. The explicit contract is that _nothing
> > and absolutely nothing_ outside of core VFS code can directly peak into
> > struct mnt_idmap internals. That's the only invariant we care about.o
>
> It would be good if we could keep all these somewhat internal exports
> as EXPORT_SYMBOL_GPL, though.

Dear Christoph,

Well noticed! Thanks, I will do it.

Kind regards,
Alex

>
