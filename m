Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0481E4478F4
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Nov 2021 04:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237255AbhKHDte (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 7 Nov 2021 22:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbhKHDtd (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 7 Nov 2021 22:49:33 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5635EC061570;
        Sun,  7 Nov 2021 19:46:50 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id l43so28892977uad.4;
        Sun, 07 Nov 2021 19:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9nBWp9x5Rv8RULMTkkYNHSeR8IARMsDNq5Ic4+DBrJM=;
        b=XSw/+dEIxpypUSQo/Vl2b7kVjoRJIxiMWBFon+C6mZa5JyBApUL1XotT5wFTpiGTnC
         491wis+FxrkelC0D5DEMexNclbYGapggBMA0sTF3E9cb++lwQU4cMUrfoCY+DzxYvFIi
         +z38vfGXL9Elh4Oe+RzQwXXqtwvTOZuvvZ7RO84EHSrmxBx7bKUy1unEPAomMRF8V3H7
         S23hXJYxEvvIvsXTzdTww5KophSz/jvaTqJug8YAveb69GBK2Y7+WOLwRLh4M7f7s4Ou
         tezplb9rEW0WTCwH4eQSv5RrB0GXaSqqRvn+PbBsYbg9Pw8ZxhbQDn4tTdOs36Dvzkj2
         WwdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9nBWp9x5Rv8RULMTkkYNHSeR8IARMsDNq5Ic4+DBrJM=;
        b=KCEQIdDVBgpWzoY3kkJyl/+udDP8gfo+/HTkn1g9hDlOEl2+vAV67kFdjYTha/dqzO
         nA8duGItET4Ap3Hquh+gS4/7urSIfZYD1btUWz9fun3ZtHQC2uSWnFuQWHFMBOOu65RO
         GNXzlq7XEZjYM/k8UbYCHbj0sJPKOfF6i4d7m7P8BZLPrTJyuKp5QOgMuUmtFvZ4+9kh
         wz+3nmWatFPFfUNGqWegNIfSqmwz22Ihhl/8K7uZeQumq1encYR/Xi5oiqtfB0a7kqqu
         vMos+i+9ZwFTpQ7XU7BkjIvjaCNfIIz/tDze19eHcijpc+r/knAxTzwU7pDgxcmoa2FP
         tzNQ==
X-Gm-Message-State: AOAM530P6ZsI/QpwwzC3YWCYhfoFQkSSbg5a1HOBg1Cj3Rnp94tL7uvJ
        /e+cnqZsf0op/e9oCnbOBOZvcXPNrDYqytuTKLs=
X-Google-Smtp-Source: ABdhPJyXCLKNUV7mPnWrydjDue+FTshJHu0pwhQkbTqSlm4vz6QJ7Fipp/VIPNsv5a5rp72COHXpYTrud1HY6FmF1e0=
X-Received: by 2002:a67:e003:: with SMTP id c3mr7887950vsl.51.1636343209149;
 Sun, 07 Nov 2021 19:46:49 -0800 (PST)
MIME-Version: 1.0
References: <20211104123147.1632-1-lhenriques@suse.de> <20211104123147.1632-2-lhenriques@suse.de>
In-Reply-To: <20211104123147.1632-2-lhenriques@suse.de>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 8 Nov 2021 04:46:40 +0100
Message-ID: <CAOi1vP8QYm+JR7c2_t5uSk-8jmqTmRs4WNYhDAoYfgar2cPw4Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ceph: libceph: move ceph_osdc_copy_from() into
 cephfs code
To:     =?UTF-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>, Xiubo Li <xiubli@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Nov 4, 2021 at 1:31 PM Lu=C3=ADs Henriques <lhenriques@suse.de> wro=
te:
>
> This patch moves ceph_osdc_copy_from() function out of libceph code into
> cephfs.  There are no other users for this function, and there is the nee=
d
> (in another patch) to access internal ceph_osd_request struct members.
> Thus, instead of changing ceph_osdc_copy_from() to return the request,
> simply move it where it is needed.

Hi Luis,

ceph_alloc_copyfrom_request() does exactly that -- returns the request.
I have dropped this sentence from the changelog but wanted to check if
you meant to keep the change instead of just moving and renaming.

Thanks,

                Ilya
