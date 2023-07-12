Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D130B750895
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Jul 2023 14:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbjGLMp0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Jul 2023 08:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbjGLMpZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Jul 2023 08:45:25 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F97C170E
        for <ceph-devel@vger.kernel.org>; Wed, 12 Jul 2023 05:45:24 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4f96d680399so10329663e87.0
        for <ceph-devel@vger.kernel.org>; Wed, 12 Jul 2023 05:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689165922; x=1691757922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PXKP1JtfwIxsWgPgm7+Uyx6r8kFv3kYpWf00+vZ851M=;
        b=mBf8JifQ/uXIbqw4u3qCCMyCV5I4mM7/ew8bzdPlcdCxmTJlpfhDtiy4Flh5M6ww4N
         A+y4f1bKLxHmdJObCzzHJ8C/q434bB6jxJ3B/L43LZDNVzRzEW5aq56L/y8pMm5OjE2j
         ojiJCugeNoEMcVZdyaghplTG00GXTTa/uxlSr3Buf71yV1lRlVzeJlCnm9dVns/cG3ih
         Y1ZJ7xivssskgsD8FSo12O+ZiTNfWnR/gzdPak3o0Js7hqyQEE1fbrbdXdL8m+eR7U7w
         Y0k73soxGU6N1y1BoGDPCIuyaJkKoRynBUJ+RgCIqeVwGcP/wTilAMlbIBYcyZqpVa/3
         OBDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689165922; x=1691757922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PXKP1JtfwIxsWgPgm7+Uyx6r8kFv3kYpWf00+vZ851M=;
        b=SdT39XhOY/asG/msB/LbP/DHTd6BBd5WABcEVdkN415wk/2aniUPj5du8TaJO/+twn
         qQ/CK6DzQrZj7k1ZVLfLG19vQjsXujNy/upU/nDyMUu+z/TQqEh07vM7eGGZNH18KGjO
         PWytYkefsS8MBILhPQgRg6vIcJjDJse8RRcCUpSNeG3/zxX56bNB+lSVaQluUV8JP0Vz
         ZseP/oZ/D9aKUDuF8JHVIjnsfuNty6fT8v5rpD9KRaEj9sWW6dwkGlD/zfQvkGfnGQ7Y
         mObiyeeutREQ/BZj6Fg9B4fA1LMErTMGisvEy1kVbSCZIQul4zWAGF9ZxP322VdkCHj0
         11Ow==
X-Gm-Message-State: ABy/qLa5LZ8SM5aEfbFjlA4aiAqTcmeJEtjWsP1xE51V05YY0Oh2e18A
        b41XYfwBpVGnhmWzA7RdAER533NI/1dU6Ra9Eyw=
X-Google-Smtp-Source: APBJJlFGW0QRORUy3Ml6T/XhpS1+vG+YxSVKd7vNrD+q9XqtOCPYIiOO/o3T56JOn/eeR6EuPu4dnwL4V5oP0z3A86g=
X-Received: by 2002:a2e:740a:0:b0:2b6:c4be:8397 with SMTP id
 p10-20020a2e740a000000b002b6c4be8397mr16387232ljc.20.1689165922103; Wed, 12
 Jul 2023 05:45:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230712120718.28904-1-idryomov@gmail.com> <0f75ee65-67c6-4d65-a41b-1cd3944f4bc2@ieee.org>
In-Reply-To: <0f75ee65-67c6-4d65-a41b-1cd3944f4bc2@ieee.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 12 Jul 2023 14:45:10 +0200
Message-ID: <CAOi1vP8vs5Pa_CaXWoM9HNT7+Rmd5S9XmpYqs469bgJa_LdzqA@mail.gmail.com>
Subject: Re: [PATCH] libceph: harden msgr2.1 frame segment length checks
To:     Alex Elder <elder@ieee.org>
Cc:     ceph-devel@vger.kernel.org, Thelford Williams <thelford@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jul 12, 2023 at 2:34=E2=80=AFPM Alex Elder <elder@ieee.org> wrote:
>
> On 7/12/23 7:07 AM, Ilya Dryomov wrote:
> > ceph_frame_desc::fd_lens is an int array.  decode_preamble() thus
> > effectively casts u32 -> int but the checks for segment lengths are
> > written as if on unsigned values.  While reading in HELLO or one of the
> > AUTH frames (before authentication is completed), arithmetic in
> > head_onwire_len() can get duped by negative ctrl_len and produce
> > head_len which is less than CEPH_PREAMBLE_LEN but still positive.
> > This would lead to a buffer overrun in prepare_read_control() as the
> > preamble gets copied to the newly allocated buffer of size head_len.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: cd1a677cad99 ("libceph, ceph: implement msgr2.1 protocol (crc an=
d secure modes)")
> > Reported-by: Thelford Williams <thelford@google.com>
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > ---
> >   net/ceph/messenger_v2.c | 41 ++++++++++++++++++++++++++--------------=
-
> >   1 file changed, 26 insertions(+), 15 deletions(-)
> >
> > diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> > index 1a888b86a494..1df1d29dee92 100644
> > --- a/net/ceph/messenger_v2.c
> > +++ b/net/ceph/messenger_v2.c
> > @@ -390,6 +390,8 @@ static int head_onwire_len(int ctrl_len, bool secur=
e)
> >       int head_len;
> >       int rem_len;
> >
> > +     BUG_ON(ctrl_len < 0 || ctrl_len > CEPH_MSG_MAX_CONTROL_LEN);
>
> Doesn't the ctrl_len ultimately come from the outside?  If so
> you should not do BUG_ON() with bad values.

It does, but it's now checked in decode_preamble().  This is
a secondary defense for which BUG_ON feels appropriate.

Thanks,

                Ilya
