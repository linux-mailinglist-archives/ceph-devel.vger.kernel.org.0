Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615E467D09F
	for <lists+ceph-devel@lfdr.de>; Thu, 26 Jan 2023 16:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbjAZPuA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 Jan 2023 10:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231823AbjAZPty (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 Jan 2023 10:49:54 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06D447EF6
        for <ceph-devel@vger.kernel.org>; Thu, 26 Jan 2023 07:49:53 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id v19so1542333qtq.13
        for <ceph-devel@vger.kernel.org>; Thu, 26 Jan 2023 07:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dreamsnake-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rqO8ksouIs85m1WYonTdBL9ZD7llT4s/rqlXWAIF170=;
        b=D5yoV9zsKbs+pjJ8538gn+C09xq0HLaBkiuDtaHpH5J2Au0FOdeiP2bTI+Vyrq1tQY
         wn/EJiGQOFqVSm0L2DV0py2m+7AXYzY7uk/ubFA132feGTpdRjgnqnGMxWHvUOUm9eJ6
         X4C3qkPEWFYJnuG+2+coku7LivXffatZZPzE45iWMqAGA2S/bAwdxnLNV/h6MeTGMQoT
         famFRFyqv04N6PQUfzHKxbodk9HsfQcGmAQD7L7s5NKT+/gDeGnTlzXrx7Kq7zeVruvh
         8+8rUexDQIM4xk3GP3IKJSMkkbI6cpSn2hdy1ZNDj5fop5yB4EGFbguF9zz8kGXV6vKz
         Wcpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:in-reply-to:to:references:date:subject:mime-version
         :content-transfer-encoding:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rqO8ksouIs85m1WYonTdBL9ZD7llT4s/rqlXWAIF170=;
        b=VDXkVQ4qsL4ZwK0uaEbA0oXbC2F7+uViTMQelziZ2cPY/0nINEXwz/JZTXK7TwEzQz
         KtZCYhpmpw1DQNsbhYsEhjKr37O0/k7nDl5yGsgzUvNoH0Qep+OLC0xWwPjlEaCBpHe/
         4+ONb9+PGMZQJd0e5kpD/SgvZj1eNew2/GfXyFbVYu54Meic9/idr4EUGGl+k5JxQoc2
         kzgKr4HgLzACJpJIaJFvfEd0gGTsjUpvolmifEpES1cVNXsKi9aD7Urhe5tdlSoErL1n
         NbxezEGsC6Q+f6snR7W8fIWCeIVKokW2DB+Y1WCgfXUTy6vlw01d0zHohc8XuhfBubcU
         LB1A==
X-Gm-Message-State: AFqh2kqYn9JEUSIfGKON9jg73zRUWMZ9QQQf+Y9xVbWMv76YAQ82WqzU
        4uTjo/P3qBEWGj1jSHzxefxwVyoC3gbNo5U=
X-Google-Smtp-Source: AMrXdXtX6Fj7A786FavMq0CHzrZYl6+dQfiboWagG5meKDLCfBSW2X/LsTkJO1G2GF/AiMOv29JLpg==
X-Received: by 2002:a05:622a:4015:b0:3b0:7755:ab80 with SMTP id cf21-20020a05622a401500b003b07755ab80mr58503066qtb.67.1674748192197;
        Thu, 26 Jan 2023 07:49:52 -0800 (PST)
Received: from smtpclient.apple ([2600:4041:410:f200:d518:e5c:287c:64ea])
        by smtp.gmail.com with ESMTPSA id i12-20020ac84f4c000000b003b63c9c59easm874230qtw.97.2023.01.26.07.49.51
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Jan 2023 07:49:51 -0800 (PST)
From:   Anthony D'Atri <aad@dreamsnake.net>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: rbd kernel block driver memory usage
Date:   Thu, 26 Jan 2023 10:49:40 -0500
References: <Y9FffDxl2sa9762M@fedora>
 <CAOi1vP8+nQMsGPK-SW-FG4C2HAgp76dEHeTEwQ2xxi2oJLH1aA@mail.gmail.com>
 <Y9KP7EX9+Ub/StL/@fedora>
To:     ceph-devel@vger.kernel.org
In-Reply-To: <Y9KP7EX9+Ub/StL/@fedora>
Message-Id: <BFF8E7E5-9500-47FB-8700-C87CEDBA3AE5@dreamsnake.net>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

>>=20
>> There is a socket open to each OSD (object storage daemon).

I=E2=80=99ve always understood that there were *two* to each OSD, was I =
misinformed?

>>  A Ceph cluster may have tens, hundreds or even thousands of OSDs =
(although the
>> latter is rare -- usually folks end up with several smaller clusters
>> instead a single large cluster).

=E2=80=A6 though if a client has multiple RBD volumes attached, it may =
be talking to more than one cluster.  I=E2=80=99ve seen a client exhaust =
the file descriptor limit on a hypervisor doing this after a cluster =
expansion.

>> A thing to note is that, by default, OSD sessions are shared between
>> RBD devices.  So as long as all RBD images that are mapped on a node
>> belong to the same cluster, the same set of sockets would be used.

Before =E2=80=A6 Luminous was it? AIUI they weren=E2=80=99t pooled, so =
older releases may have higher consumption.
>=20

