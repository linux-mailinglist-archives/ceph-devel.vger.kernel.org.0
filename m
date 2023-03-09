Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB876B1C5C
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Mar 2023 08:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjCIHcO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Mar 2023 02:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjCIHbr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Mar 2023 02:31:47 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F133CDF73B
        for <ceph-devel@vger.kernel.org>; Wed,  8 Mar 2023 23:31:11 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id bi9so1134219lfb.2
        for <ceph-devel@vger.kernel.org>; Wed, 08 Mar 2023 23:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1678347067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ha/3mU3Llx0Wa0WUDy/uPl76sON4g9057OoIU9zRL5M=;
        b=Qtcqr7ffdSk4foYwmHCYlCxkgdTb3gmp7/PVtv7leT7UJxqj1XYVgAKrSWxc+lFTS/
         Rev8wfsj0fMgfNjI1T4d/s6gMi2grLLQfG9T/Ua4sxcfkwkcVAm/T5DEktpu5BnipoB7
         v8L02Nd4TsqrsxZizzBjmEw6Cm3KhBYJLUM/kJc2Rz7Z3f2M/P31gM3ldwkw5dTon9B8
         U2KyFcBKmOBVdLZJ7H6nzmUsXq9NQ92DFNXPautpgG/MFC3IL33JnVFR/0xRoQOygyHl
         /XgnbCXOxdKSoaFLjCZWjnhdfLz9mZjrOeu13FI1RiCIZvLonWvp1AwKZO20/h6epr2e
         GjRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678347067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ha/3mU3Llx0Wa0WUDy/uPl76sON4g9057OoIU9zRL5M=;
        b=ni3ALrESc7fbcfVUUh0eVi7DlK5UdI6PW7kbYjLvhJYiWSJrE+I7sAWDO54DojV4R6
         tnTqri6mf+qOqtIprVhyWpSjH94RrshYGCA6zLCvaezi2jmarzvBZwXgN6TJKMd76qep
         h/EE89gALsZD3huiLwHH8ziSbhakLsAhCeUgqnEhAXK35YZDPuvU/X8TLwl5PRYRAtG2
         L3uLWZp6HpZ2DRzNdULpYQkveO6AosfkSLtTAKg+swD0zexCqXT7EDsYnHDtoldZDmaK
         DpDmVpUFu0g1WyQJq6TFKh/NX66mgVeSJkuJvpzx3n5OGwaG3fShTJkcOA0wlk6IbvG0
         xSfg==
X-Gm-Message-State: AO0yUKXAbqtf+jg0AcEau2zJUKGeHj6iVZnpf4FTgpB2uDRHMG/6615w
        c3kzX0PV/fkJ+WgAdLQfJ2/ycjQY8EMb8hwsK8m7cw==
X-Google-Smtp-Source: AK7set/CzLKvBYZT7akl9keu/O524xE6wDtFMN64SvHQrgjOET2PcHeMncNYZT90K5hf1/HQwtE9Gcpwc6bJMuvu2OE=
X-Received: by 2002:a19:7517:0:b0:4dd:805b:5b75 with SMTP id
 y23-20020a197517000000b004dd805b5b75mr6471232lfe.7.1678347067247; Wed, 08 Mar
 2023 23:31:07 -0800 (PST)
MIME-Version: 1.0
References: <20230302130650.2209938-1-max.kellermann@ionos.com>
 <c2f9e0d3-0242-1304-26ea-04f25c3cdee4@redhat.com> <CAKPOu+_1ee8QDkuB4TxQBaUwnHi4bRKuszWzCb-BCY44cp1aJQ@mail.gmail.com>
 <cf545923-e782-76a7-dd94-f8586530502b@redhat.com>
In-Reply-To: <cf545923-e782-76a7-dd94-f8586530502b@redhat.com>
From:   Max Kellermann <max.kellermann@ionos.com>
Date:   Thu, 9 Mar 2023 08:30:56 +0100
Message-ID: <CAKPOu+-jCt6NoVaR=z6c-D-PY1skdt6u-2sKkzd8GFDHbsQdxQ@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/mds_client: ignore responses for waiting requests
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, jlayton@kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Mar 9, 2023 at 6:31=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:

> I attached one testing patch based yours, just added more debug logs,
> which won't be introduce perf issue since all the logs should be printed
> in corner cases.
>
> Could you help test it ?

The patch now runs on one of our clusters, and I'll get back to you as
soon as the problem occurs again. Thanks so far!
