Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92067BBE07
	for <lists+ceph-devel@lfdr.de>; Fri,  6 Oct 2023 19:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbjJFRwc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 6 Oct 2023 13:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbjJFRwa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 6 Oct 2023 13:52:30 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BFACA;
        Fri,  6 Oct 2023 10:52:25 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 46e09a7af769-6c4b9e09521so1534782a34.3;
        Fri, 06 Oct 2023 10:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696614744; x=1697219544; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ArDuk2HSf4KVe4K0cIVJjpZVXfnpGd1T4YLw1ogG0O4=;
        b=eSZ31aulR0W3SiGSEKBoBtxX0fuXlc7LZLpvQzwm3CGljaZaMUREdN6Spz8kukJTnZ
         PyhR9ptUIvhDrv4oxpE0epGmWfLuYRmH1e968oOCgC2lr1fwOFfKFLKJ0TYHyW8ZHbki
         ZEGxhXBswY1OQm5wLPM/Ojll0mhFlpXMCKPHvUrQDGWbUhUpKseZV2dLf5G48eGMMwZJ
         Bk1Z96hgI9qjEgtP0uOXSFBMaBkalTO2HNqIKhVLQeJT3e8Mc/qdpQ0taiNiDQ1If8Lz
         YB21ImTSFvMl5y72gnjf+LhcTmsmHKABBPPjLqi0MwqVcAJHaKoRblaJntoKlncUv30F
         Z/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696614744; x=1697219544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ArDuk2HSf4KVe4K0cIVJjpZVXfnpGd1T4YLw1ogG0O4=;
        b=P7tD9Zi9h0zoQKGr/mJPXbL5017OJ0D47zAPajZr17DzYwXcqMne27/q8C3/LxYcsI
         Y13ScYF3YL4XP4Hg6Aci0dbsEgBEfidnmR/3HD0iWIlgQoGPwlzHDVgymj45iTTG3d3g
         zCgWD4aDh8Mzxc/Y1Ft1qhUcdv6neG0CY5olN9K8gX59iZjHVYa4AXUasTOqH4bjcH4+
         CaG8mHss85/m0+N8hSzNMj2yjazuSnqqMMnMgXs3meYqXECvrjgTWw7aAD8rnr0vw/41
         FFndWanTaNImS6I6aY9Zuu2U65yTQSwStB3NGVzbE9GnINY2V+fLx5gI3KbkG4R01iqI
         wMdg==
X-Gm-Message-State: AOJu0YygWFSGc4tfGUIu1SjCI6LHfE9NvS3oG/ATiWIMbvmlJ/ozoVkK
        hVzndEokiSRRgCZmeNrOAsUtDPR8edN9d+WUJZM=
X-Google-Smtp-Source: AGHT+IGY/J+AkYKsY2SPAIvp4vFVQLUaKYRJIH1v8lxux3yrxpeGsHEPIZT+kBt/TWNPG6ldAidiY1uT7POBqbExbEU=
X-Received: by 2002:a9d:75ce:0:b0:6af:9b42:9794 with SMTP id
 c14-20020a9d75ce000000b006af9b429794mr8677815otl.35.1696614744244; Fri, 06
 Oct 2023 10:52:24 -0700 (PDT)
MIME-Version: 1.0
References: <20231004233827.1274148-1-jrife@google.com> <CAOi1vP-9L7rDxL6Wv_=6uuxVV_d-qK7StyDLBbvpZZcXmg6+Mg@mail.gmail.com>
 <CADKFtnT6CYG779McrTQh+Y2fDz8Nzy6sFE-qSGbxWenh=fborg@mail.gmail.com>
In-Reply-To: <CADKFtnT6CYG779McrTQh+Y2fDz8Nzy6sFE-qSGbxWenh=fborg@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 6 Oct 2023 19:52:12 +0200
Message-ID: <CAOi1vP_eDBxA4tcSHthk_mfCfcy5svrMuw42+JweM+41D4q=ow@mail.gmail.com>
Subject: Re: [PATCH] ceph: use kernel_connect()
To:     Jordan Rife <jrife@google.com>
Cc:     ceph-devel@vger.kernel.org, xiubli@redhat.com, jlayton@kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Oct 6, 2023 at 5:45=E2=80=AFPM Jordan Rife <jrife@google.com> wrote=
:
>
> Ilya,
>
> Sorry for the confusion. I forgot to mark 0bdf399342c5 ("net: Avoid
> address overwrite in kernel_connect") for stable initially, so I
> forwarded it separately to the stable team a while back. It has since
> been backported to all stable branches 4.19+.

Thanks for the clarification, now applied.

                Ilya
