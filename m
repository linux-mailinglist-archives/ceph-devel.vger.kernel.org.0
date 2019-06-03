Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74FA933181
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 15:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728619AbfFCNuC (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 09:50:02 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38307 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728040AbfFCNuC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 3 Jun 2019 09:50:02 -0400
Received: by mail-qt1-f196.google.com with SMTP id l3so9398095qtj.5
        for <ceph-devel@vger.kernel.org>; Mon, 03 Jun 2019 06:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7dJoOCP6NA1MWjH1shf2VEL7HLEMPUkbn+XRn04sQEI=;
        b=BmaAQR5m0Rw7h1gf1pAVc8IPNcoWB3TjfxVWfvkp6ZSZe8j5UkcKkKH2cClSkrhdYY
         a3T47Tk5ESLriD1H/BpnrrVeKNxIQw9qqgZcve/OsvUq2t2EjHf3nj5ullwBES8SmWDE
         6815q0dTZHaibUZqZMPbvINdN1FAWjvq9Fdl1DMt9A00z2wrTwetjrHmRgRJ8czVH7Wj
         1vxnbPX7R6PJlVHgTN6hqnY/litueTpa97lx6tz8Zd6yITFV5rHJkUfgj9B+hZpbGu4k
         zujUhnTUL+IUjCm/I+i1zNth4K7Vvb9EYLJgD6pOMuGhBPJHmI5LF2k7CBVjTir3S5MO
         ZntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7dJoOCP6NA1MWjH1shf2VEL7HLEMPUkbn+XRn04sQEI=;
        b=HRVECCWqU8i89APZxRrCc8rq+ibmR4pduZaAPAGMzS90RRs8KYO8QK0udKJVxg4QZM
         L+3dLakccm+zg6Tj2lx4DC3yZEidr+TYMzc+evvaqVh2dnn0AvQYBHTjNfsg/wAfz+VB
         0bascC202Utvo61CRQLHexTYUZsZ3vjCTK8YOmyQhLiieReqoul/PVMdAviEXNmtRusx
         AFPKTDqDumT+S9qVvRb38+GhTJ6asLep+15YfYpKw6x+exvuPI6cC0QMeP8sJn1hBAw0
         /PvOAKwILfGBtpQmGn+NX6Mgn3O5mxYKXhdx4DwO/jG+dNmlpBf68GC1khMHmTA/sRfD
         LA3g==
X-Gm-Message-State: APjAAAU7AiHJra7/CXVO+XlLowqAwuHgVLFpQEcsVq7YLZ/IF/G+kh3N
        6BOj1xDnqyzJ/rEIxvdEPk/gEuqJinCjuNdCGbpnKaGA
X-Google-Smtp-Source: APXvYqwS67XnvGuqyEUus91tx9zYdrBxwMj0/nYCviflWMvyGNLG4Xs4F/wsKY3PKcMbfoqJ4Tv2GYJiilrWmO17uz0=
X-Received: by 2002:a0c:d146:: with SMTP id c6mr9196623qvh.76.1559569801968;
 Mon, 03 Jun 2019 06:50:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190531122802.12814-1-zyan@redhat.com> <20190531122802.12814-2-zyan@redhat.com>
 <CAOi1vP8O6VviiNKrozmwUOtVN+GtvA=-0fEOXcdbg8O+pu1PhQ@mail.gmail.com>
In-Reply-To: <CAOi1vP8O6VviiNKrozmwUOtVN+GtvA=-0fEOXcdbg8O+pu1PhQ@mail.gmail.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Mon, 3 Jun 2019 21:49:49 +0800
Message-ID: <CAAM7YAmY-ky2E_9aPHNSNMmmTp9rC+Aw-eBMN_KP1suY_u+Wmg@mail.gmail.com>
Subject: Re: [PATCH 2/3] ceph: add method that forces client to reconnect
 using new entity addr
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     "Yan, Zheng" <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@redhat.com>,
        Jeff Layton <jlayton@redhat.com>,
        Luis Henriques <lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 31, 2019 at 10:20 PM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Fri, May 31, 2019 at 2:30 PM Yan, Zheng <zyan@redhat.com> wrote:
> >
> > echo force_reconnect > /sys/kernel/debug/ceph/xxx/control
> >
> > Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
>
> Hi Zheng,
>
> There should be an explanation in the commit message of what this is
> and why it is needed.
>
> I'm assuming the use case is recovering a blacklisted mount, but what
> is the intended semantics?  What happens to in-flight OSD requests,
> MDS requests, open files, etc?  These are things that should really be
> written down.
>
got it

> Looking at the previous patch, it appears that in-flight OSD requests
> are simply retried, as they would be on a regular connection fault.  Is
> that safe?
>

It's not safe. I still thinking about how to handle dirty data and
in-flight osd requests in the this case.

Regards
Yan, Zheng

> Thanks,
>
>                 Ilya
