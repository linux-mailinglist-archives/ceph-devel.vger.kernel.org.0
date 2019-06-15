Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45A9446DDC
	for <lists+ceph-devel@lfdr.de>; Sat, 15 Jun 2019 04:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfFOCle (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Jun 2019 22:41:34 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36801 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbfFOCle (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Jun 2019 22:41:34 -0400
Received: by mail-qt1-f195.google.com with SMTP id p15so4787761qtl.3;
        Fri, 14 Jun 2019 19:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yQ21ZLTY4RLs3iCwXQ/kkbuwACv/NnfO4tOeczfZY60=;
        b=jxl5nOKfyRLXyx2VWgc1moJ5CiBIhaKj69hQEyyAxgoT/lWw02iRRkWodxJWYQMGCM
         OnT1uNt/uY9cwxMJH5hsafz710swXVWjmGMESazI46sMMenCcmIQgM3H0zIfg/ZBiwSt
         D5RltyqTPYaMg5hibHCVdHH9exVNiPkW5dwV6L1fvTkr0IpwTB1itRp9iz12SyHaTGww
         mFc3JuzkZOcEJHd8ieK3za9kCMksjhgKSPW0xcBd1XptkzHjwjzRsxSsnojHUGBuerzN
         1UwC3er4q9JPDnCEo+M8Wmt0KGerZ07KJ4C8IGnL5nrDX5cihs6YaQvDJtdRH4hTBOhg
         mqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yQ21ZLTY4RLs3iCwXQ/kkbuwACv/NnfO4tOeczfZY60=;
        b=hYtn1KCunEidOomCAiEPCzPzRZguABMwXOL9c0/vElVMCWEofTj3rH+ayB+DELG/Au
         XiKx33Bopb9HBJ0GjJZXsCUN5TKeaouZ9E2jGKfPOC/2oEfU2d5ptPXTHLPhTXiRVehF
         n3Dh3o2ozh1A9IMcZLaltwxSe+NCKsg51u+FH5yp44+iTVNjm2zKnGG53Ynls8kzYFAX
         swM/Xc5nlwAc/msU8dq3asBybezobDRI3VrU13XvDgoIul0gd1GqmEa3teZWbAPVZ7wo
         uNE/HpwCNtftnNJS0UGG+I/G5fWjs90kv7Fnri6//rmnGZfRa+2SeCOf0pci6HfRcEPy
         saAQ==
X-Gm-Message-State: APjAAAVupFVOGubDe3OWWit56YSedBIJAZIsNddEdwY7Fp6Zl1hwjdPG
        8Q5N8I4bQZHu8+M0Eg9bcXGyGrRFbuRa7ZUSWRk2uVXR
X-Google-Smtp-Source: APXvYqxH+mhpDhI2qltwu89UwIsOjPGqHLTkqWWqpOi1GyC//4dnc5oSdU3HjOgk+ow2Y36YJbnoCzJJ+6Qj/h5mH6E=
X-Received: by 2002:ac8:87d:: with SMTP id x58mr84178585qth.368.1560566492712;
 Fri, 14 Jun 2019 19:41:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190614134625.6870-1-jlayton@kernel.org> <20190614134625.6870-2-jlayton@kernel.org>
In-Reply-To: <20190614134625.6870-2-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Sat, 15 Jun 2019 10:41:21 +0800
Message-ID: <CAAM7YAnZ=NtsOuR0Pm82fWCSUdFLkJ7NLNk+fNK9+T4viW=_1Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] lib/vsprintf: add snprintf_noterm
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>, agruenba@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 14, 2019 at 9:48 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> The getxattr interface returns a length after filling out the value
> buffer, and the convention with xattrs is to not NULL terminate string
> data.
>
> CephFS implements some virtual xattrs by using snprintf to fill the
> buffer, but that always NULL terminates the string. If userland sends
> down a buffer that is just the right length to hold the text without
> termination then we end up truncating the value.
>
> Factor the formatting piece of vsnprintf into a separate helper
> function, and have vsnprintf call that and then do the NULL termination
> afterward. Then add a snprintf_noterm function that calls the new helper
> to populate the string but skips the termination.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  include/linux/kernel.h |   2 +
>  lib/vsprintf.c         | 145 ++++++++++++++++++++++++++++-------------
>  2 files changed, 103 insertions(+), 44 deletions(-)
>
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 2d14e21c16c0..2f305a347482 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -462,6 +462,8 @@ extern int num_to_str(char *buf, int size,
>  extern __printf(2, 3) int sprintf(char *buf, const char * fmt, ...);
>  extern __printf(2, 0) int vsprintf(char *buf, const char *, va_list);
>  extern __printf(3, 4)
> +int snprintf_noterm(char *buf, size_t size, const char *fmt, ...);
> +extern __printf(3, 4)
>  int snprintf(char *buf, size_t size, const char *fmt, ...);
>  extern __printf(3, 0)
>  int vsnprintf(char *buf, size_t size, const char *fmt, va_list args);
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 791b6fa36905..ad5f4990eda3 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -2296,53 +2296,24 @@ set_precision(struct printf_spec *spec, int prec)
>  }
>
>  /**
> - * vsnprintf - Format a string and place it in a buffer
> + * vsnprintf_noterm - Format a string and place it in a buffer without NULL
> + *                   terminating it
>   * @buf: The buffer to place the result into
> - * @size: The size of the buffer, including the trailing null space
> + * @end: The end of the buffer
>   * @fmt: The format string to use
>   * @args: Arguments for the format string
>   *
> - * This function generally follows C99 vsnprintf, but has some
> - * extensions and a few limitations:
> - *
> - *  - ``%n`` is unsupported
> - *  - ``%p*`` is handled by pointer()
> - *
> - * See pointer() or Documentation/core-api/printk-formats.rst for more
> - * extensive description.
> - *
> - * **Please update the documentation in both places when making changes**
> - *
> - * The return value is the number of characters which would
> - * be generated for the given input, excluding the trailing
> - * '\0', as per ISO C99. If you want to have the exact
> - * number of characters written into @buf as return value
> - * (not including the trailing '\0'), use vscnprintf(). If the
> - * return is greater than or equal to @size, the resulting
> - * string is truncated.
> - *
> - * If you're not already dealing with a va_list consider using snprintf().
> + * See the documentation over vsnprintf. This function does NOT add any NULL
> + * termination to the buffer. The caller must do that if necessary.
>   */
> -int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
> +static int vsnprintf_noterm(char *buf, char *end, const char *fmt,
> +                           va_list args)
>  {
>         unsigned long long num;
> -       char *str, *end;
> +       char *str;
>         struct printf_spec spec = {0};
>
> -       /* Reject out-of-range values early.  Large positive sizes are
> -          used for unknown buffer sizes. */
> -       if (WARN_ON_ONCE(size > INT_MAX))
> -               return 0;
> -
>         str = buf;
> -       end = buf + size;
> -
> -       /* Make sure end is always >= buf */
> -       if (end < buf) {
> -               end = ((void *)-1);
> -               size = end - buf;
> -       }
> -
>         while (*fmt) {
>                 const char *old_fmt = fmt;
>                 int read = format_decode(fmt, &spec);
> @@ -2462,18 +2433,69 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
>                         str = number(str, end, num, spec);
>                 }
>         }
> -
>  out:
> +       /* the trailing null byte doesn't count towards the total */
> +       return str-buf;
> +}
> +EXPORT_SYMBOL(vsnprintf_noterm);

export static function?

> +
> +/**
> + * vsnprintf - Format a string and place it in a buffer
> + * @buf: The buffer to place the result into
> + * @size: The size of the buffer, including the trailing null space
> + * @fmt: The format string to use
> + * @args: Arguments for the format string
> + *
> + * This function generally follows C99 vsnprintf, but has some
> + * extensions and a few limitations:
> + *
> + *  - ``%n`` is unsupported
> + *  - ``%p*`` is handled by pointer()
> + *
> + * See pointer() or Documentation/core-api/printk-formats.rst for more
> + * extensive description.
> + *
> + * **Please update the documentation in both places when making changes**
> + *
> + * The return value is the number of characters which would
> + * be generated for the given input, excluding the trailing
> + * '\0', as per ISO C99. If you want to have the exact
> + * number of characters written into @buf as return value
> + * (not including the trailing '\0'), use vscnprintf(). If the
> + * return is greater than or equal to @size, the resulting
> + * string is truncated.
> + *
> + * If you're not already dealing with a va_list consider using snprintf().
> + */
> +int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
> +{
> +       int ret;
> +       char *end;
> +
> +       /* Reject out-of-range values early.  Large positive sizes are
> +          used for unknown buffer sizes. */
> +       if (WARN_ON_ONCE(size > INT_MAX))
> +               return 0;
> +
> +       end = buf + size;
> +
> +       /* Make sure end is always >= buf */
> +       if (end < buf) {
> +               end = ((void *)-1);
> +               size = end - buf;
> +       }
> +
> +       ret = vsnprintf_noterm(buf, end, fmt, args);
> +
> +       /* NULL terminate the result */
>         if (size > 0) {
> -               if (str < end)
> -                       *str = '\0';
> +               if (ret < size)
> +                       buf[ret] = '\0';
>                 else
> -                       end[-1] = '\0';
> +                       buf[size - 1] = '\0';
>         }
>
> -       /* the trailing null byte doesn't count towards the total */
> -       return str-buf;
> -
> +       return ret;
>  }
>  EXPORT_SYMBOL(vsnprintf);
>
> @@ -2506,6 +2528,41 @@ int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
>  }
>  EXPORT_SYMBOL(vscnprintf);
>
> +/**
> + * snprintf_noterm - Format a string and place it in a buffer
> + * @buf: The buffer to place the result into
> + * @size: The size of the buffer, including the trailing null space
> + * @fmt: The format string to use
> + * @...: Arguments for the format string
> + *
> + * Same as snprintf, but don't NULL terminate the result.
> + */
> +int snprintf_noterm(char *buf, size_t size, const char *fmt, ...)
> +{
> +       va_list args;
> +       int ret;
> +       char *end;
> +
> +       /* Reject out-of-range values early.  Large positive sizes are
> +          used for unknown buffer sizes. */
> +       if (WARN_ON_ONCE(size > INT_MAX))
> +               return 0;
> +
> +       /* Make sure end is always >= buf */
> +       end = buf + size;
> +       if (end < buf) {
> +               end = ((void *)-1);
> +               size = end - buf;
> +       }
> +
> +       va_start(args, fmt);
> +       ret = vsnprintf_noterm(buf, end, fmt, args);
> +       va_end(args);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL(snprintf_noterm);
> +
>  /**
>   * snprintf - Format a string and place it in a buffer
>   * @buf: The buffer to place the result into
> --
> 2.21.0
>
