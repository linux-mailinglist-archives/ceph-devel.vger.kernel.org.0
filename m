Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440137AE8A4
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Sep 2023 11:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbjIZJJf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Sep 2023 05:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbjIZJJe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 26 Sep 2023 05:09:34 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511C6E5
        for <ceph-devel@vger.kernel.org>; Tue, 26 Sep 2023 02:09:27 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 38308e7fff4ca-2c00df105f8so137390541fa.2
        for <ceph-devel@vger.kernel.org>; Tue, 26 Sep 2023 02:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1695719365; x=1696324165; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BHvpEB8wp3FZZchRCw0huayDAuLFSj0z42NgLQ6/www=;
        b=bZ1MEadvVZa0MOoEOIYkjiH9wNfNMeRvs0CD0FJ9+wrBY2POfLn025SJrAaQ7uYlNO
         Yv46Q4R/IrWSHlrus3Yt0yAFd0XSr4om4DawtrpSLONgIj5Zd4xQ7irT4OzmjQQ68DC1
         FNZDmjK+iH839GP8af2iWeHIH4ixVcCz5cMtxPR2BlD5IHXuw6hqvp9Mo9/jEJjxM+gS
         /APMXxCpruMVq7FfvP9CRRwMRCSfqsPzNYLvqgDNiNOLUvWyxn55m902uiuojYcflfDX
         sjWQGGq82FiWkbSVHLcPWGwPNPrFsWFgJFlJGBNxj30N2hxIiliQSY9RJBWFzkfOH7f9
         kJ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695719365; x=1696324165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BHvpEB8wp3FZZchRCw0huayDAuLFSj0z42NgLQ6/www=;
        b=UXC6pqY2m3MILDPU4F2JkGHsbmh17B+RzpilOIC3UdjTWHJtbtVoRgrQNlqm/7HY7L
         2pUbF70LC3KlOzv/u1SRdurUSP0eND39oQxV5w7f4upkctlT7SfN2b4NY5gxjSxEanIs
         PW6CTlzbLXQLIoGDP2E6Wh+vfGo2NH+gYgwAOsbKpUa3LczxuPzrZYMlKn/K37PxUcTR
         6ZBstwLsJ7rzTAKwKtXGT2fwTrG6d8oHa+Rn83rzklUGfm2RwkQdeRJ9pGbe7xTSJau1
         5z3kUM9TL0d1InDfzqzTz1cR39XuRvEbhCVD9f4JKPHjaXgDIOf7IpmOyh2AQ3G1cR3o
         /4UA==
X-Gm-Message-State: AOJu0YxhOcfg1gb677wqXZOi1NmhLJa8/yQZSr0nf5VLEgN5sbdXJ/oP
        YC5fBxyDScU5SlirgDnm+YaeL1uu7Ll7PG5u0AcNxQ==
X-Google-Smtp-Source: AGHT+IHC4BQ5m624pk4IaH8MAnjb4yJd+swjEVBzW6j1o5xuyPU125GWtueO+iyoNJP6gBrIhMlsO/mrqsZVz0zxm7Q=
X-Received: by 2002:a2e:2417:0:b0:2c0:2ab7:9ab5 with SMTP id
 k23-20020a2e2417000000b002c02ab79ab5mr8036773ljk.12.1695719365559; Tue, 26
 Sep 2023 02:09:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230922062558.1739642-1-max.kellermann@ionos.com>
 <CAOi1vP80WvQhuXgzhvzupQP=4K2ckgu_WpUCtUSy5M+QdDycqw@mail.gmail.com>
 <CAKPOu+-yUOuVh+3818iJ-GH968EHHQ0Pc3d8Rj4veO3k-xLk+g@mail.gmail.com> <CAOi1vP9QdfB0uxd64XcpREWFTqrJm0QNORYzrGvQBLOu4CrDWg@mail.gmail.com>
In-Reply-To: <CAOi1vP9QdfB0uxd64XcpREWFTqrJm0QNORYzrGvQBLOu4CrDWg@mail.gmail.com>
From:   Max Kellermann <max.kellermann@ionos.com>
Date:   Tue, 26 Sep 2023 11:09:14 +0200
Message-ID: <CAKPOu+87ka3z6haYXystbHFCUMRh4mtvOEFmEPsJ_vCW9_81RA@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs/ceph/debugfs: make all files world-readable
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Sep 26, 2023 at 10:46=E2=80=AFAM Ilya Dryomov <idryomov@gmail.com> =
wrote:
> No, "ceph" command (as well as "rbd", "rados", etc) can be run from
> anywhere -- it's just a matter of installing a package which is likely
> already installed unless you are mounting CephFS manually without using
> /sbin/mount.ceph mount helper.

I have never heard of that helper, so no, we're not using it - should we?

This "ceph" tool requires installing 90 MB of additional Debian
packages, which I just tried on a test cluster, and "ceph fs top"
fails with "Error initializing cluster client: ObjectNotFound('RADOS
object not found (error calling conf_read_file)')". Okay, so I have to
configure something.... but .... I don't get why I would want to do
that, when I can get the same information from the kernel without
installing or configuring anything. This sounds like overcomplexifying
the thing for no reason.

Max
