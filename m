Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593462ADC71
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 17:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbgKJQvn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 11:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730530AbgKJQvm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 10 Nov 2020 11:51:42 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC43C0613CF
        for <ceph-devel@vger.kernel.org>; Tue, 10 Nov 2020 08:51:42 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id u21so14894318iol.12
        for <ceph-devel@vger.kernel.org>; Tue, 10 Nov 2020 08:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=53k55M+oILGVhs0FSZOmdV6MZoskqqHysedQWRup8I8=;
        b=u5HQFN/crn9RN5zJHFwAqCCYzdNMMUYBh63o+2SlSjE+SSTc3w+4hUqOPKEPFWToO0
         tsfBzkdnUwi2UYBrjJcu/sumj0dGPfdej4C6MQeXfmS2g6+wDxaqG9HujkQuDVimWTbU
         Ds9lGfLOAngrM/qdmozkRrcTP60TkBM/STuoDC2MLvLZs7K3NIF0ERrov8k2pa8mEbcw
         cbdCDdvOKxgNgmoTEqFFpIOuJQB7WGJ5d0xJdb16ms7otGBdaloSqJDKr+fDHj/iPJOU
         +iJnf64uu/HqIiAes+mrkOTmWmkIHIIozhBW+Ie7/j4OG0UdPjaYynjd/23Y3txa5DSR
         1hgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=53k55M+oILGVhs0FSZOmdV6MZoskqqHysedQWRup8I8=;
        b=gFEql6qQVeGBjDo8JU6lypLbJk8Qgv9fxI+mA1fXcy7kVSIrncmj52PALCKUioQ2RD
         ZS0eMgHyD8QSfWDSlXKdySwLvl99xSJCwP102imfLVfT22z0fPEqtVdI1FHcwgCAM1o9
         3ljR6QQP8adqXMt6sf0TUDwU49q/dibm5OEPsbzDuYz0dzQIEtTg8jtru79GJXjCXD8v
         JLcHIjvrHT+0IYoR9/x2pJ0yrWXQHYfe48+XLfNIn4XPtSdyicSyyAGWurXDFABFvtDM
         APEyBXCRdFZ0kpsDcLyHUUD65ZEnWQ89jvKlYyCQ16PbUi+4+F5WBbqVEE7W3Q0jb9vN
         MDiw==
X-Gm-Message-State: AOAM532CoBjRSEylEtGaK3Fh1dA7MRNiAf+u9iO8ZqE9AHS71iYa22co
        bUxK+4f9fojpNfBIy59UvQqXPqQZr3KALD03YVU=
X-Google-Smtp-Source: ABdhPJxxcCDwjindALh3N+VSi31+H51N3ZWTE7LtkPDOTsU8vZF7QcgHI0KlmwxHs/CuxsNYL5dg4v0HLQCwLcpNz/U=
X-Received: by 2002:a5e:8e01:: with SMTP id a1mr10902408ion.7.1605027101694;
 Tue, 10 Nov 2020 08:51:41 -0800 (PST)
MIME-Version: 1.0
References: <20201110132008.GA90192@nstpc>
In-Reply-To: <20201110132008.GA90192@nstpc>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 10 Nov 2020 17:51:41 +0100
Message-ID: <CAOi1vP8wYX+P2u9kToucTFW3fMZ4d-G-md02UmUAfGZr9HQQfw@mail.gmail.com>
Subject: Re: [PATCH] libceph: remove unused defined macro for port
To:     "Liu, Changcheng" <changcheng.liu@aliyun.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 10, 2020 at 2:20 PM Liu, Changcheng
<changcheng.liu@aliyun.com> wrote:
>
> 1. monitor's default port is defined by CEPH_MON_PORT
> 2. CEPH_PORT_START & CEPH_PORT_LAST are not needed.
>
> Signed-off-by: Changcheng Liu <changcheng.liu@aliyun.com>
>
> diff --git a/include/linux/ceph/msgr.h b/include/linux/ceph/msgr.h
> index 1c1887206ffa..feff5a2dc33e 100644
> --- a/include/linux/ceph/msgr.h
> +++ b/include/linux/ceph/msgr.h
> @@ -7,15 +7,6 @@
>
>  #define CEPH_MON_PORT    6789  /* default monitor port */
>
> -/*
> - * client-side processes will try to bind to ports in this
> - * range, simply for the benefit of tools like nmap or wireshark
> - * that would like to identify the protocol.
> - */
> -#define CEPH_PORT_FIRST  6789
> -#define CEPH_PORT_START  6800  /* non-monitors start here */
> -#define CEPH_PORT_LAST   6900
> -
>  /*
>   * tcp connection banner.  include a protocol version. and adjust
>   * whenever the wire protocol changes.  try to keep this string length
> --
> 2.25.1
>

Applied.

Thanks,

                Ilya
