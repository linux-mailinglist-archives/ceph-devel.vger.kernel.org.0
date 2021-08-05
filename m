Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2053E14F6
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Aug 2021 14:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240539AbhHEMoZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Aug 2021 08:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240237AbhHEMoZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Aug 2021 08:44:25 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F90C061765
        for <ceph-devel@vger.kernel.org>; Thu,  5 Aug 2021 05:44:11 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id t3so4763620qkg.11
        for <ceph-devel@vger.kernel.org>; Thu, 05 Aug 2021 05:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tDpytBce8X6C8fP1uEC9pHgDL2v8EYhgecw9OyVA0OQ=;
        b=Ca7xpM0Ts/Dj4t9+FgSGgHhneoeyvFvSo1fjWx6AKYgg2sYc3PaXBcSXrdppiSp7US
         0AZ1PWf6smzBTRbWjR4Z+hW8SWwiW0rrqnP2eS68JMQsNUxqw+BYMZ30a99K+udi/7pp
         W/OALMXEvPXPnBMXhRPZyEX0Z68unLS+0i84e8cvb2CDvaXuc8pD/bce17qgLzii4b5E
         hIK3515ffm5qHHFOhH8PIgVL9FhHqKP5xcYUdF4qPVgy7j7+NwpAMczIqoXUnxN5HBOo
         Cp9fEdYZ6HPHo87d8hHSMYNqX/Z1CZ13gihzZMLZA+dckOlq15apMVDs9P2FNEzdt604
         MABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tDpytBce8X6C8fP1uEC9pHgDL2v8EYhgecw9OyVA0OQ=;
        b=Y5ScmPo7eKJuq5CLR6XxzQFgHdWc6HLM0OqAaZbgonjqQvRGVqnHFrA1onCgQfVfpo
         CKjQgtDk8wAG864kg9/kFvS2MhGjm1vvCPKG3L5QAgFVDJMdZDJm0X6VEfuyIQNnzbU4
         X/JpGLtN7bJCNFpnAXAPrPFkOGFIOX1kY5UOP0UyVCacF/djuhnD+j5wPPFNz0ZX1yl3
         KSxirEQysI3CH39+nkC2c6NnXQBDNDkTjNzS1XFaLdlTyAIEbb1f9oxXAk7/eqGAPUO3
         kBycY0Mi/zSizj7tCYY+Z1xsBZ+aVMo9ZMitK7uviMR/D6z5booJEIOMpHxRCsAwdnYn
         K6Fw==
X-Gm-Message-State: AOAM532fJkqPwKGwueZqw4XK7pP1vIx2lNkGPasHmYsEV5jwrxu6Ivzc
        iWlah13u4ZZA/g5rPT+FprkcSU1BnNaQZn5AvNk=
X-Google-Smtp-Source: ABdhPJxcCLSW+bknG+TZvV70BHS/bOJnSActVnUO+s6nPANSI0l70bPpbm+T1+RpmTpTiDmj6sCujjNntaC+1P+dung=
X-Received: by 2002:a05:620a:2099:: with SMTP id e25mr4741413qka.448.1628167450472;
 Thu, 05 Aug 2021 05:44:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210729071851.1244874-1-satoru.takeuchi@gmail.com> <CAOi1vP8Bbo9bNOOShB2DdjfOG7u0vVqJjUkz5YXb2CBm9JEqOA@mail.gmail.com>
In-Reply-To: <CAOi1vP8Bbo9bNOOShB2DdjfOG7u0vVqJjUkz5YXb2CBm9JEqOA@mail.gmail.com>
From:   Satoru Takeuchi <satoru.takeuchi@gmail.com>
Date:   Thu, 5 Aug 2021 21:43:59 +0900
Message-ID: <CAMym5wvnH=dSd2n+jAKJbSVRVnpzw8e=P9=EePLRfwudj6t8wg@mail.gmail.com>
Subject: Re: [PATCH] ceph: print fsid with mon id and osd id
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Ilya,

> While adding fsid would help with disambiguation of messages from libceph
> instances for different clusters, it wouldn't help in the case of multiple
> libceph instances for the same cluster (i.e. see noshare mapping option).

I didn't know the multi-libceph case. Thank you for letting me know.

> For a full disambiguation we need a (cluster fsid, client gid) pair.  For
> example, something like:
>
>   libceph (<fsid> <gid>): <message>
>
>   libceph (ef1ab157-688c-483b-a94d-0aeec9ca44e0 4181): osd10 down
>
> One concern is it might be too verbose to be included in every message,
> but OTOH it would make each message truly stand on its own.

I'd like to embed gid to messages since these messages are shown not too often.
I'll revise my patch later.

Thanks,
Satoru
