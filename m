Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17B84652D
	for <lists+ceph-devel@lfdr.de>; Fri, 14 Jun 2019 18:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfFNQ4q (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Jun 2019 12:56:46 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:45548 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfFNQ4q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 14 Jun 2019 12:56:46 -0400
Received: by mail-ot1-f66.google.com with SMTP id x21so3244191otq.12
        for <ceph-devel@vger.kernel.org>; Fri, 14 Jun 2019 09:56:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cNzgw8zU6lYxY9116+VTCavjD+4v/EZJ92kV6MCy3Hw=;
        b=suKR1Na7pw5qpJvH5xqrKXAAaFWY4hN5KOwbfto5ytgTyz9r50G3myqK2FveZGGAGI
         fDrfmVdTUBpbxtEOBt8b00PGCPhdMnQC97/co+2Qqsm1FAc79fxLi6uBuMHK+Pnb8aaT
         63EcmvZ12eO3zWRdsQOFE2qBe0EJxcHK6mV7kW6RC4RHvg0UH5p9/GA/11uBZUe3qUU2
         SWo4/N5jq3FCHkThbB4rsEJC3ok6Js+fM7ma66Rhy4+wDvGrdT+UQOlQ847Q/go84Mde
         i44WdBH1KF4dZMPMVY2OlMMKiWkh4ogNjXJHbT1eZFbN9A5vbTdZ9YGsSzEaKDFz31Rw
         2NQA==
X-Gm-Message-State: APjAAAV6hnY6i+L+Uaa94DsIDA6KHTF0U6zNBEUuqNcMNFxM3+TLwa4o
        B55MufgfxDU6sBkvWdhlQ//ZxLDlmBj8uj7EL2lfDA==
X-Google-Smtp-Source: APXvYqy2rNq9+R6u/xnYlzAgf1nwxm3PpCU3YNzHzhAoC+UXWr4Wmm6PlURMQyQ3rNfDdi+Dv87oUDmHrlRke6mba2A=
X-Received: by 2002:a9d:704f:: with SMTP id x15mr17973354otj.297.1560531405363;
 Fri, 14 Jun 2019 09:56:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190614134625.6870-1-jlayton@kernel.org>
In-Reply-To: <20190614134625.6870-1-jlayton@kernel.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Fri, 14 Jun 2019 18:56:34 +0200
Message-ID: <CAHc6FU5QVQQ43TZNZ7A53D3Ka3e_qq9GEtV_fZt7C5A+xrWm_A@mail.gmail.com>
Subject: Re: [PATCH 0/3] ceph: don't NULL terminate virtual xattr values
To:     Jeff Layton <jlayton@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 14 Jun 2019 at 15:46, Jeff Layton <jlayton@kernel.org> wrote:
> kcephfs has several "virtual" xattrs that return strings that are
> currently populated using snprintf(), which always NULL terminates the
> string.
>
> This leads to the string being truncated when we use a buffer length
> acquired by calling getxattr with a 0 size first. The last character
> of the string ends up being clobbered by the termination.
>
> The convention with xattrs is to not store the termination with string
> data, given that we have the length. This is how setfattr/getfattr
> operate.
>
> This patch makes ceph's virtual xattrs not include NULL termination
> when formatting their values. In order to handle this, a new
> snprintf_noterm function is added, and ceph is changed over to use
> this to populate the xattr value buffer. Finally, we fix ceph to
> return -ERANGE properly when the string didn't fit in the buffer.

This looks reasonable from an xattr point of view.

Thanks,
Andreas

> Jeff Layton (3):
>   lib/vsprintf: add snprintf_noterm
>   ceph: don't NULL terminate virtual xattr strings
>   ceph: return -ERANGE if virtual xattr value didn't fit in buffer
>
>  fs/ceph/xattr.c        |  49 +++++++-------
>  include/linux/kernel.h |   2 +
>  lib/vsprintf.c         | 145 ++++++++++++++++++++++++++++-------------
>  3 files changed, 130 insertions(+), 66 deletions(-)
>
> --
> 2.21.0
>
