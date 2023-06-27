Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCB073FC30
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Jun 2023 14:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjF0Mwm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jun 2023 08:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjF0Mwk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 27 Jun 2023 08:52:40 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD5A2728
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 05:52:28 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-988883b0d8fso622391866b.1
        for <ceph-devel@vger.kernel.org>; Tue, 27 Jun 2023 05:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687870347; x=1690462347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uiXCCrt0jei7X1IVN7MvmQ4VQLoKZ0zzSomNoR0MwKU=;
        b=WcMrbJ5t+fF3Ai1F6+2jqBlePJFNruvLXsYlSpRaFLMBGaIJhQC2jsTHsACFO0DXN3
         Sr5pezMH51Z/bmdSuXlqNtg3ixMkfsVmRNZsyVptkP5rpL1rXF9ihTM8p/9wzdKDvNAa
         hmvuGFPyQ+3W0c5X0GFOOQAvRbOEH9IjhyDKC8GGocWVPBurTX/uIE9CfmvuYxk9VZ6l
         L913twNC8cEaiIjibTzjMwUHyNcoyWTbBZYtzXZ07AkFsp8vgRo0Fm2VLOplntLYukAO
         qI1oHha8/nCfgCTBJjtewmoH2imacuPHTuI7e0soxtxv5Q5mCnS4oBJRwioYcHWzLh9u
         XkQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687870347; x=1690462347;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uiXCCrt0jei7X1IVN7MvmQ4VQLoKZ0zzSomNoR0MwKU=;
        b=hceUDUy+iSNAEaonagTw/HItAK/4h/Z4QmpaU7X6o0+v3AZNjBndE22D9qHWYNwmYp
         uK4ePKanXEzYmoVYhXWn6QxVE7b8uRGA4WoXULmWI3biF4nc0l1nMCrHgHZkX8qhi2MH
         s8KcF42XRh2l5MehD7rWz7e+WeaHcodwZXWgYP59zH6+EaYBMMb11DooGVr0AtF2leT8
         P93TiL7n0kddbV4Upb92DDMGZe9U2dJBowLHSHwCbpsKEQANJeOI13CM4pr/9gKDbcNq
         he6u5h3qPeZKpiKOhWfyE7Tuyl2oE7ddNrL5ivhoRt2ELU2VtoLhEihV082W4nWJwK0o
         FJ8Q==
X-Gm-Message-State: AC+VfDzG0vGmwfGZcOmlo0zTI3RG6ONuXdy1DTJYTbwLveaylMldhEG6
        oDAwRGVXCakX+M90ys1VYGC5pDbGVFTE0MR8qiA=
X-Google-Smtp-Source: ACHHUZ5yRL52+ulQ4AahhlvF+OMiPadF5+i/LteIEsqf8JyDo8ssef8KRW8rPirZr5414F08Qk/0dQJrIO4Tu3F1Kh0=
X-Received: by 2002:a17:907:160c:b0:991:e849:e13b with SMTP id
 hb12-20020a170907160c00b00991e849e13bmr3826077ejc.10.1687870347309; Tue, 27
 Jun 2023 05:52:27 -0700 (PDT)
MIME-Version: 1.0
References: <3130627.1687863588@warthog.procyon.org.uk>
In-Reply-To: <3130627.1687863588@warthog.procyon.org.uk>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 27 Jun 2023 14:52:15 +0200
Message-ID: <CAOi1vP-EsPU59-LGZGf55fqGCZ3zuXDK+8VyK=d-MtEnarQ8dw@mail.gmail.com>
Subject: Re: Ceph patches for the merge window?
To:     David Howells <dhowells@redhat.com>
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 27, 2023 at 12:59=E2=80=AFPM David Howells <dhowells@redhat.com=
> wrote:
>
> Hi Ilya,
>
> Is there a branch somewhere that are the ceph patches for this merge wind=
ow?

Hi David,

Not quite yet but ceph-client/master [1] should be very close now.

[1] https://github.com/ceph/ceph-client/commits/master

Thanks,

                Ilya
