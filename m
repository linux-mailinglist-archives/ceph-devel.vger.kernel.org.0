Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE327AE583
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Sep 2023 08:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbjIZGJp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Sep 2023 02:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbjIZGJj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 26 Sep 2023 02:09:39 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0722EFB
        for <ceph-devel@vger.kernel.org>; Mon, 25 Sep 2023 23:09:33 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2c135cf2459so117538351fa.0
        for <ceph-devel@vger.kernel.org>; Mon, 25 Sep 2023 23:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1695708571; x=1696313371; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bsSkGdr3lR16TyaxQNyV8wP3RWSIxpxumK3mahZfc/s=;
        b=YN2dmb6IE+DxPOTkI333RIN8ATkayptRV/QvcUkUEoddmeZG3+9819pPc4g632L4Ck
         /3XsRfdpdoV8xtx2vNfQQyrH25Vu8LEXzHCNFvL7BBJJyWZfzeGkcnND8jtNpTc+cDw8
         Q184xDXaThaQvXnZoirp5WXi9PWk5KcoA9wZpBta1p4GkGLay3P058GPI7JglgG9pg4R
         45IV47LXNRXXdXxDYc1RKjW7Pb5S/OjDvSvNoZln+ek+f/P2w2FXNjhVVgOj5mCjJq+1
         XnM78E+PQxZ+VGjeWQXXh92nRfvqY+tWrzRbLQ2mdCtvIem+Jt5w7NkA4EJS1Q8wBjDS
         yeuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695708571; x=1696313371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bsSkGdr3lR16TyaxQNyV8wP3RWSIxpxumK3mahZfc/s=;
        b=Fz6wJCBXXuwAQlZE+XclQQLtVT7ITC97y4pesAcY6GGQ8bl74Q+qSljGQalOZ8G64g
         g6sS/BbPOLaqI9+UCTe3UiIl/fKQKoEp13y0IXTbyk0ALUrIPjB8FN7R+yVArFYDGN+J
         7PlA3LZC7QwE6vP1DTmNMTRHAIgVXdeQ5xCYZSYEn9lcJwFFB6nFw4o7QbqsfkcFGUPt
         nkOTEnxp78/t/OeKqIE2fOtzvuE/NuuiiOdNtQYXlgoPyLx3hxRBSz+e6d99SdrcvFJG
         Ri7YFGOHqPVvx6s4aE3GAp9E6KB7xVmUbTijx6OJiKYd2HDfZNtMBglD1dOnleCcViPx
         p3EQ==
X-Gm-Message-State: AOJu0Yw7jMitz6y3NPkBhlPj910rfUOK60i2LyXuklUSKUqIC8lS+Oz1
        /JU+pHI7rs3hLVsiUAwgZ5K2OtfA0tlptqUY3Axxj8M5u9zm+DSLgHI=
X-Google-Smtp-Source: AGHT+IGB22iFd0gGVWxd884bYZkv8M30TEfy4t+P+lAtOO7/8Q7P+BMwJUNw0veRp18N5y3rVUuq8IESK1TUjvPweMs=
X-Received: by 2002:a2e:9b4b:0:b0:2bd:d34:f892 with SMTP id
 o11-20020a2e9b4b000000b002bd0d34f892mr7816213ljj.3.1695708571258; Mon, 25 Sep
 2023 23:09:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230922062558.1739642-1-max.kellermann@ionos.com> <fd88660f-0d23-16fb-2408-ac18ad01778e@redhat.com>
In-Reply-To: <fd88660f-0d23-16fb-2408-ac18ad01778e@redhat.com>
From:   Max Kellermann <max.kellermann@ionos.com>
Date:   Tue, 26 Sep 2023 08:09:20 +0200
Message-ID: <CAKPOu+-wLkKSrbbDiWktAnFAO8OooryX-p7LVvvRW=Ho44nfGQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs/ceph/debugfs: make all files world-readable
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Sep 25, 2023 at 7:18=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
> I am not sure whether will this make sense. Because the 'debug' under
> '/sys/kernel/' is also only accessible by privileged process.

Not exactly correct. It is by default accessible to processes who have
CAP_DAC_OVERRIDE and additionally it is accessible to (unprivileged)
processes running as uid=3D0 (those two traits usually overlap).
But we don't want to run kernel-exporter as uid=3D0 and neither do we
want to give it CAP_DAC_OVERRIDE; both would be too much, it would
affect much more than just (read) access to debugfs.
Instead, we mount debugfs with "gid=3DX,mode=3D0710". That way, we can
give (unprivileged) processes which are member of a certain group
access to debugfs, and we put our kernel-exporter process in that
group.

We can use these mount options to change debugfs defaults, but if a
debugfs implementor (such as cephfs) decides to override these global
debugfs settings by passing stricter file permissions, we can't easily
override that. And that is what my patch is about: restore the ability
to override debugfs permissions with a mount option, as debugfs was
designed.

Max
