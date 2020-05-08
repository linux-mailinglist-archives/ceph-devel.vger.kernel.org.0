Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6F51CA576
	for <lists+ceph-devel@lfdr.de>; Fri,  8 May 2020 09:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgEHHxX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 8 May 2020 03:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbgEHHxX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 8 May 2020 03:53:23 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EE0C05BD43;
        Fri,  8 May 2020 00:53:23 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id n11so603013ilj.4;
        Fri, 08 May 2020 00:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oln5tfVAI4AvyS+UujKlstyWBX8E0Amueo8uekJEDow=;
        b=rvn363Nh6khqCOwipKRo/7445am5iUcrbzBAfUgybe2KXka23kogTbJeKgGBA8TCwY
         CMXx6RBdgwCwJw3aNR6sYphAEKCfNonqcQuX/BLEl0TgTCG+EiT2F4Mzww/KRDxZu6lT
         GkunygFaUDxbuj/VX4LwecDMQ6BdeBnRw4hxqnFvSEyfLbWGeCQfw2Py0dM6/g0jHk1x
         C/rrUuA6TQQh+QjhsQX6prdsURVWKk7JCLt+ac7vWlPAnj8663lMPXl3gd6v0CanfR8O
         1trcj6drLzDSlnhMONlNYjQ7XFjrHMpKnbSoM14Le7oxRqJE3e6l0iv4+Oj6QSdqYKps
         5jtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oln5tfVAI4AvyS+UujKlstyWBX8E0Amueo8uekJEDow=;
        b=rHwqDAjN5Dw4iirzGHmMB9n49lsUUfrNqb9W4OSzbaFl+EoI/lsdjrF+MjcO75KLmy
         PWpRbmisDh/+xhbQ7E5GwaVBREtJet9dHcvXat1undr39GCKhQuvHJGMPgbSHhyMhEoy
         YO2kfnGLLdn5uUFclQuMWglMlb1qcYRbloY13j1PtPzsB5zkMYdRBMwSQN9XaktlZjO5
         eYypuUdO2kWaveOFBytoH66AOeGTu9wrXiJ1AENvceCJMX0rP+vcIU5rZ9quLODUapJQ
         5IF8Fofj31f5gH8pOnP6vmvhQKhIY09RQLevR3juw+Oe495PBglUEEI7djDBcWoxQXYI
         Rl/w==
X-Gm-Message-State: AGi0PuZ24WG6j5/dWNbWCJpxaMh5w3CysjsXX2+2jmEJZ8A7FhSDXEWD
        tZ2DXe7m9z9niqwpzzA8phy3iqJX5qTZtb1c0XE=
X-Google-Smtp-Source: APiQypJ5QkWaYggBPojZ+2cOBK5uBfFXYlHAPkBbqsEzh96I/qqbe/8UYQcNEtQ9dk2MfhoS1Yw7i2wMoQx6dwDvL/E=
X-Received: by 2002:a92:d5cf:: with SMTP id d15mr1486961ilq.131.1588924402219;
 Fri, 08 May 2020 00:53:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200507185138.GA14076@embeddedor>
In-Reply-To: <20200507185138.GA14076@embeddedor>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 8 May 2020 09:53:25 +0200
Message-ID: <CAOi1vP-w-doHK2zHJQixLneub5qwdnz8DC_9toDEvuPy7i72NA@mail.gmail.com>
Subject: Re: [PATCH] libceph: Replace zero-length array with flexible-array
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 7, 2020 at 8:47 PM Gustavo A. R. Silva
<gustavoars@kernel.org> wrote:
>
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
>
> struct foo {
>         int stuff;
>         struct boo array[];
> };
>
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
>
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
>
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
>
> sizeof(flexible-array-member) triggers a warning because flexible array
> members have incomplete type[1]. There are some instances of code in
> which the sizeof operator is being incorrectly/erroneously applied to
> zero-length arrays and the result is zero. Such instances may be hiding
> some bugs. So, this work (flexible-array member conversions) will also
> help to get completely rid of those sorts of issues.
>
> This issue was found with the help of Coccinelle.
>
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  include/linux/ceph/mon_client.h |    2 +-
>  include/linux/crush/crush.h     |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/ceph/mon_client.h b/include/linux/ceph/mon_client.h
> index dbb8a6959a73..ce4ffeb384d7 100644
> --- a/include/linux/ceph/mon_client.h
> +++ b/include/linux/ceph/mon_client.h
> @@ -19,7 +19,7 @@ struct ceph_monmap {
>         struct ceph_fsid fsid;
>         u32 epoch;
>         u32 num_mon;
> -       struct ceph_entity_inst mon_inst[0];
> +       struct ceph_entity_inst mon_inst[];
>  };
>
>  struct ceph_mon_client;
> diff --git a/include/linux/crush/crush.h b/include/linux/crush/crush.h
> index 54741295c70b..38b0e4d50ed9 100644
> --- a/include/linux/crush/crush.h
> +++ b/include/linux/crush/crush.h
> @@ -87,7 +87,7 @@ struct crush_rule_mask {
>  struct crush_rule {
>         __u32 len;
>         struct crush_rule_mask mask;
> -       struct crush_rule_step steps[0];
> +       struct crush_rule_step steps[];
>  };
>
>  #define crush_rule_size(len) (sizeof(struct crush_rule) + \
>

Applied.

Thanks,

                Ilya
