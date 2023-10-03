Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7C47B67EA
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Oct 2023 13:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239993AbjJCLas (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Oct 2023 07:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240481AbjJCLaq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 3 Oct 2023 07:30:46 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677EFD7
        for <ceph-devel@vger.kernel.org>; Tue,  3 Oct 2023 04:30:42 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id 006d021491bc7-57ad95c555eso431711eaf.3
        for <ceph-devel@vger.kernel.org>; Tue, 03 Oct 2023 04:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696332641; x=1696937441; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=um98NmdkzDsiSk9C8A2rWPOfG4kpiR22bfuPzeUHIuk=;
        b=deueux9YbQCzTXAttEwDVoaxaEmtERerEmAZ06vUude7ADgOXCabvrUQeFc/GdaPWq
         ixPY+GXLnxm22wWFGcJqdQHGpFQIHsYBo63WxLFMuB+LqsjRjuB3UYXE2+EnKm7ujqKK
         7cFQpPDNBRIbSdewZc9xQRVC+a3xxhxPDR+Zg1TLNHzP0qbdcO8q0qPHkSqH5yUMo/So
         bzihQB6SB4qu73cJjRTO86HDZxag1MUYHJ6Hiu++ldta/fb/YLG3ZhjP51jlpQlByYC5
         Z+qHtfx4BhPQNUQqvHUdtKissQShlQi6Yxh8vDWq93Ks2A/pjZfm1VLrvhvwx2EToyR9
         bc3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696332641; x=1696937441;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=um98NmdkzDsiSk9C8A2rWPOfG4kpiR22bfuPzeUHIuk=;
        b=laD0HdQWGRGbvJWmIoJC9XSnbvjHE+fwZEZmF7xy1iWfrg6jIPS0tvDbfw/Mxi2D2y
         oMmYXBu8yR3b1EMep5jI5D6Mz+JdkyFY472Jo/0/KquM8huUwa9xZ8n7kS9KsNE2nHwU
         vhje7SVANEyPdIk0jZoCssfM1kI0dom9i1khT/XgIxd4gYWTGnqoGRm0rMxWCqLHXaF/
         tQ9QYjGwSTsZgfc3Ir3dTffyP24IJwLEOIL4CnrHNbl9Va60Bicnog8yKUC2NdGdtCJY
         3VOT3AaF/atTyqJqqy0hF5aY+2YMQEq96sG4xshBcbj+Y3UPf/DGT6mL9uUxzJ03uCO0
         LWMg==
X-Gm-Message-State: AOJu0YzIUxr4rQ42YQgxVjNwN8HS8Pd+Yg89PUJaTe05a7UcHfFNIBrt
        CiEwhbPPxKZ4gAMegz+6Pl4EEBtxURaAIJqrV1o=
X-Google-Smtp-Source: AGHT+IE631fkhm4Eo0ckkvhL7uHFfRR6AwoZd5Tt59CgxJuwSRh05vdP2GP3Ub/WwYoq+lzZgMdTz0tBPWY7/zewxVM=
X-Received: by 2002:a4a:9b43:0:b0:57b:5c28:4169 with SMTP id
 e3-20020a4a9b43000000b0057b5c284169mr12156867ook.1.1696332641537; Tue, 03 Oct
 2023 04:30:41 -0700 (PDT)
MIME-Version: 1.0
References: <20231003110556.140317-1-vshankar@redhat.com>
In-Reply-To: <20231003110556.140317-1-vshankar@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 3 Oct 2023 13:30:29 +0200
Message-ID: <CAOi1vP89eWiqUy9yZhWcSzujFre8YSnrCiNMczE_cX3QbDRsEg@mail.gmail.com>
Subject: Re: [PATCH] Revert "ceph: enable async dirops by default"
To:     Venky Shankar <vshankar@redhat.com>
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, xiubli@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Oct 3, 2023 at 1:06=E2=80=AFPM Venky Shankar <vshankar@redhat.com> =
wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> This reverts commit f7a67b463fb83a4b9b11ceaa8ec4950b8fb7f902.
>
> We have identified an issue in the MDS affecting CephFS users using
> the kernel driver. The issue was first introduced in the octopus
> release that added support for clients to perform asynchronous
> directory operations using the `nowsync` mount option. The issue
> presents itself as an MDS crash resembling (any of) the following
> crashes:
>
>         https://tracker.ceph.com/issues/61009
>         https://tracker.ceph.com/issues/58489
>
> There is no apparent data loss or corruption, but since the underlying
> cause is related to an (operation) ordering issue, the extent of the
> problem could surface in other forms - most likely MDS crashes
> involving preallocated inodes.
>
> The fix is being reviewed and is being worked on priority:
>
>         https://github.com/ceph/ceph/pull/53752
>
> As a workaround, we recommend (kernel) clients be remounted with the
> `wsync` mount option which disables asynchronous directory operations
> (depending on the kernel version being used, the default could be
> `nowsync`).
>
> This change reverts the default, so, async dirops is disabled (by default=
).

Hi Venky,

Given that the fix is now up and being reviewed on priority, does it
still make sense to change the default?

According to Xiubo, https://tracker.ceph.com/issues/58489 which morphed
into https://tracker.ceph.com/issues/61009 isn't the only concern -- he
also brought up https://tracker.ceph.com/issues/62810.  If the move to
revert (change of default) is also prompted by that issue, it should be
described in the patch.

Thanks,

                Ilya
