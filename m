Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E196814B3
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Aug 2019 11:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfHEJE1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 5 Aug 2019 05:04:27 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45468 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfHEJE1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 5 Aug 2019 05:04:27 -0400
Received: by mail-io1-f67.google.com with SMTP id g20so165745434ioc.12
        for <ceph-devel@vger.kernel.org>; Mon, 05 Aug 2019 02:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FSB+2WXRFDceeOdrMsGRX2fQSiGnR71qt+eJZsFD87o=;
        b=NbZzJCT6rIJAGCFqJ5UvsLNTqx18Gw4vA2yKKQhR7J/qExFJ8wAMKp0/9RI8an3oIe
         NvNwaZYZD7JtPvmOAnDr2yMtjDX7xJMydQfcuaCcrzTfaMHYnpslg+BNfm8Jv5ZiJ8Ie
         haRoJFtOqXOQWdZ2Em6xCdbNK4fWj82+sFOn+HLkFSrqBhHkhuUk8weZfr5b5QWq9By5
         TUpOTMfGJvTsRprGCEDtGmMl4G0yzzPTo+iqssZD5MY46mkQpRvv9t3UDnobQA9RoNk5
         vEaziZBQf7LZ6dOw/y1Tdx4j/p0x2IfxcNCIUMACETw453QAzEp5OXDV7YFVJ2SSiegR
         U6Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FSB+2WXRFDceeOdrMsGRX2fQSiGnR71qt+eJZsFD87o=;
        b=geTY3p5+HOMjtwPM1XsurOKpx6Qnm10Og85jW3PqvPL6pzLGFxoxHYapXp0TYBpQbe
         YXpJUj2o/xsc8nlisNvE9LyC4Re2CIeYXGQJk4NTODCMvVpO/5riXzNNPwv3HOkRH0GA
         iSTVuNy3GBsQttgQpYoVWhuru/1f7/m2mJk8GlHCDnFkIlaqNbiJVp6M1cBNPQXeMpSh
         iqeR5gUilDRwfF7/+isZg6KMd0T4ewv1HM4pyC15MwZB8lPNmwB0mOmBjjFKW4yZzpsA
         nAl8o2B/7fbVi98HRXHMYtIGiWwbCo9ICJKjacVQoGNJDisvmAkyzqdov10nqzmaWo0Y
         i4dA==
X-Gm-Message-State: APjAAAUkpgZYC+FLjy19O4LXyWQ/ouAYe9pszZNVMTNiLMHybKybIjfy
        /Mrtygt32BYgjHPjcNyhBILlPbJaCoeQGnYM4AE=
X-Google-Smtp-Source: APXvYqzt2jB5KHzoiwIF2ccpbvBYWvA4AZLNnLoqtxxD3db0z00/S++8RZoZ6s7YUAoE2KDIYABWWgqQUN59o56VySg=
X-Received: by 2002:a02:cd82:: with SMTP id l2mr14836666jap.96.1564995866875;
 Mon, 05 Aug 2019 02:04:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190802172335.24553-1-jlayton@kernel.org>
In-Reply-To: <20190802172335.24553-1-jlayton@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 5 Aug 2019 11:07:23 +0200
Message-ID: <CAOi1vP-ZYyGGX_gJ1yDhN6BGwFkrrLpsWbikT-J4pA6ZSm_-SQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: undefine pr_fmt before redefining it
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Aug 2, 2019 at 7:23 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> The preprocessor throws a warning here in some cases:
>
> In file included from fs/ceph/super.h:5,
>                  from fs/ceph/io.c:16:
> ./include/linux/ceph/ceph_debug.h:5: warning: "pr_fmt" redefined
>     5 | #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>       |
> In file included from ./include/linux/kernel.h:15,
>                  from fs/ceph/io.c:12:
> ./include/linux/printk.h:288: note: this is the location of the previous definition
>   288 | #define pr_fmt(fmt) fmt
>       |
>
> Since we do mean to redefine it, make that explicit by undefining it
> first.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/ceph/ceph_debug.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_debug.h
> index d5a5da838caf..fa4a84e0e018 100644
> --- a/include/linux/ceph/ceph_debug.h
> +++ b/include/linux/ceph/ceph_debug.h
> @@ -2,6 +2,7 @@
>  #ifndef _FS_CEPH_DEBUG_H
>  #define _FS_CEPH_DEBUG_H
>
> +#undef pr_fmt
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
>  #include <linux/string.h>

Hi Jeff,

Looks like fs/ceph/io.c is a new file you are working on?  ceph_debug.h
should be included at the top of every file.

Thanks,

                Ilya
