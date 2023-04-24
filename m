Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD036ECB9B
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Apr 2023 13:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbjDXLyi (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Apr 2023 07:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjDXLyg (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Apr 2023 07:54:36 -0400
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF21E45
        for <ceph-devel@vger.kernel.org>; Mon, 24 Apr 2023 04:54:36 -0700 (PDT)
Received: by mail-vk1-xa2d.google.com with SMTP id 71dfb90a1353d-4404c674cefso1386688e0c.2
        for <ceph-devel@vger.kernel.org>; Mon, 24 Apr 2023 04:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682337275; x=1684929275;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a7FJt7D7PGHiQYhM8ZUO77Xvfmwmn6KKXHYSJXX3iSk=;
        b=IWHINsTtTIaFi9yNK6BN0G5X/0M2KLVpc3rLtc1R/5Htc7QufLtyrTpWdlm2mhFdeR
         x3vyh6wV5I+4FuvMTYXDE+a9JIvvDZIgwyKcCT/uuYwMxLGQ8u5kvUClpKEiaM1US+83
         qAAdSWOeaFo6cGWFwjHKV8/UJR64o6zwcsu4CoEAzfEETsOMX30SSYrApV63lRFL5vU1
         8CEt4GBl5/fYeP82WNmydSZ1uL2tw3XeyEre8w8DXasOsRr4sRzAQk5Q0rpZRYV9C9+G
         ew8QpncVJhi267N3KcrbfNX+e9+DVMr0twGFh6ujrG+ZgI3/j278B6FutLgLwB/NTqNc
         7vpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682337275; x=1684929275;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a7FJt7D7PGHiQYhM8ZUO77Xvfmwmn6KKXHYSJXX3iSk=;
        b=BjyVlIUj9GkVNi/p+LEOg8HAz3cGeKbMsmMfz3W3qvbqSJy+9BlRZg4pT4XJhbUd8F
         p7bQvfu5ch+TzTnm7NEKBsCrViRVE8q/sPyQMauiJMoQXVLbbVqVbkadGZ7Op6HHpkNP
         Zm/I6fC3Yknht6hC2vQ8jM7m9QgyCb16tP0Kb+Vld2icxoMsi37j0gqYrzBJ5eMLpC3I
         wVtQyFVH9T0dQ0OtQfgizN2n5oO67aQbj6osnTuBmyTZAqLFfx9CF1yVRG+g9K6fG1N5
         qYyjTKdNNT2BGQWWImhzWu3VLqjis0lf7LOgg/Ln5MIgW7FZAGXXAxO8p4w385cbD13T
         JxQA==
X-Gm-Message-State: AAQBX9fWoPHCGyOXO/Vyt/7HzX7YMGlK02b/YUiBFDDySwVo5iy1WyDK
        sw8+bAZuPeSNQbkq2vqaSJBsg4eAHLSaTddemX3sZtAx
X-Google-Smtp-Source: AKy350bm2R8CUqt47E6mHtsGKezviZxewiPBUaJAVEXWw6wJak3iW3AOBfSS6T7D+G7kaFxMIwdJkA+kdabTwyVOkP4=
X-Received: by 2002:a1f:4592:0:b0:443:9b17:72e9 with SMTP id
 s140-20020a1f4592000000b004439b1772e9mr3071629vka.12.1682337275017; Mon, 24
 Apr 2023 04:54:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAPy+zYVpqE6T0V=7Sq4TdaziF+Azgph00FyJ8W+tARBb57Vo0A@mail.gmail.com>
In-Reply-To: <CAPy+zYVpqE6T0V=7Sq4TdaziF+Azgph00FyJ8W+tARBb57Vo0A@mail.gmail.com>
From:   WeiGuo Ren <rwg1335252904@gmail.com>
Date:   Mon, 24 Apr 2023 19:54:24 +0800
Message-ID: <CAPy+zYXE8_oX=+0dM_QzH__mDtCAZ6AsCK=jWxm71ag9eBUw2Q@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_How_to_control_omap_capacity=EF=BC=9F?=
To:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In my cluster every osd have 55GB (db val data in same device), ceph
-v is 14.2.5. can anyone give me some idear to fix it?

WeiGuo Ren <rwg1335252904@gmail.com> =E4=BA=8E2023=E5=B9=B44=E6=9C=8824=E6=
=97=A5=E5=91=A8=E4=B8=80 19:49=E5=86=99=E9=81=93=EF=BC=9A
>
> I have two osds. these  osd are used to rgw index pool. After a lot of
> stress tests, these two osds were written to 99.90%. The full ratio
> (95%) did not take effect? I don't know much. Could it be that if the
> osd of omap is fully stored, it cannot be limited by the full ratio?
> ALSO I use ceph-bluestore-tool to expand it . Before I add a partition
> . But i failed, I dont know why.
