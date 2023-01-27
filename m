Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DB867E0E7
	for <lists+ceph-devel@lfdr.de>; Fri, 27 Jan 2023 10:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbjA0J6j (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 27 Jan 2023 04:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjA0J6i (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 27 Jan 2023 04:58:38 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9869317164
        for <ceph-devel@vger.kernel.org>; Fri, 27 Jan 2023 01:58:36 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id ss4so12183215ejb.11
        for <ceph-devel@vger.kernel.org>; Fri, 27 Jan 2023 01:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RVsv7QM65qEPfC30bJ6w0yGcKIfSr6MbIpBcVS/8cy0=;
        b=mnxA0g8yyhTKMf9QvWt6z06xVM1Wf1tuZ1DOHzTyJQC9e2Ne0GqGnbaSyTygJ98k0w
         ATK7p76IDWH42lng7mmIxcCGgTP63uT03pNa0wEM45i2prQIJ8M0TxF7E4X0cNzE72eF
         yC8j9WC92Lan7OZ4bbkQOlnjppbE+NJw31aM4Jnu9lpw9h7DYiwIQebWSfatjGw9ml0m
         q/l01Y6vKbTB24rEXfEaHFYAoC8nuJoofcd0B5MF6hyuOjQNxYRR3EGV7Ly4UihfytEw
         dgi1wxsvLcOxbKK54iil8QrYDqZAdfNwyI0twkYfKQSz31UABwfBVV8fYOshKnlKqayl
         7wug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RVsv7QM65qEPfC30bJ6w0yGcKIfSr6MbIpBcVS/8cy0=;
        b=vWjmkyu5EsL5bJcn/fLDTqnYX/QtM1+jd4pICXvKkNyCKAZwQyH/F/Ic+nVX612+Ue
         zDKgFjGPCX7KASd7reXKI0uPe3UVYjiKt1KjVxLg7Ytx+sqJntv2hay6eQ/LLPSyaAOY
         szKmM/L+nAoLBbHydghk7wzuiMyFLzKYbbzMIprnSDOltKxxeDJA2s47RNql4jbEbC6k
         I4P7h+DeUTY8u1VNLp5URMm3Em7OX0axHVs2JuYyiHwWzSNiaR89ybtlXlq3OnW+tGlA
         jizfAkkB73P37/rOQ8VCO+j+IWiY7vnKLcVNLWX11NKb7HemVuBu/K4bTScI0KtTFVPo
         D1AQ==
X-Gm-Message-State: AFqh2kprCf3x6Y2xdPhuTQGiRMf3utbedAcGS9Zf5Z/2XkL2xd0Vbevm
        paKShzxU5hMeUva3tZDOP01BNPc1suQQNsUg5THfynhb5yk=
X-Google-Smtp-Source: AMrXdXuRBNAbX7TV9mdeE0hHO9eoIYBQf8lHRXByErBZLjNhoFfpp8S620IgNQT1NfJkB/SKo/RAH7hMh2N3F+5Hvco=
X-Received: by 2002:a17:906:7754:b0:86f:2cc2:7028 with SMTP id
 o20-20020a170906775400b0086f2cc27028mr4889917ejn.133.1674813515246; Fri, 27
 Jan 2023 01:58:35 -0800 (PST)
MIME-Version: 1.0
References: <Y9FffDxl2sa9762M@fedora> <CAOi1vP8+nQMsGPK-SW-FG4C2HAgp76dEHeTEwQ2xxi2oJLH1aA@mail.gmail.com>
 <Y9KP7EX9+Ub/StL/@fedora> <BFF8E7E5-9500-47FB-8700-C87CEDBA3AE5@dreamsnake.net>
In-Reply-To: <BFF8E7E5-9500-47FB-8700-C87CEDBA3AE5@dreamsnake.net>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 27 Jan 2023 10:58:22 +0100
Message-ID: <CAOi1vP_b6PQn3wBv6RY5vLmyeAJqy3dh50pqbdaVtf98qwvcVA@mail.gmail.com>
Subject: Re: rbd kernel block driver memory usage
To:     "Anthony D'Atri" <aad@dreamsnake.net>
Cc:     ceph-devel@vger.kernel.org
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

On Thu, Jan 26, 2023 at 5:08 PM Anthony D'Atri <aad@dreamsnake.net> wrote:
>
> >>
> >> There is a socket open to each OSD (object storage daemon).
>
> I=E2=80=99ve always understood that there were *two* to each OSD, was I m=
isinformed?

Hi Anthony,

It looks like you were misinformed -- there is just one client -> OSD
socket.

>
> >>  A Ceph cluster may have tens, hundreds or even thousands of OSDs (alt=
hough the
> >> latter is rare -- usually folks end up with several smaller clusters
> >> instead a single large cluster).
>
> =E2=80=A6 though if a client has multiple RBD volumes attached, it may be=
 talking to more than one cluster.  I=E2=80=99ve seen a client exhaust the =
file descriptor limit on a hypervisor doing this after a cluster expansion.
>
> >> A thing to note is that, by default, OSD sessions are shared between
> >> RBD devices.  So as long as all RBD images that are mapped on a node
> >> belong to the same cluster, the same set of sockets would be used.
>
> Before =E2=80=A6 Luminous was it? AIUI they weren=E2=80=99t pooled, so ol=
der releases may have higher consumption.

No, this behavior goes back to when RBD was introduced in 2010.  It has
always been enabled by default so nothing changed in this regard around
Luminous.

Thanks,

                Ilya
