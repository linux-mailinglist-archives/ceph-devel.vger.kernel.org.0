Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35860504F9
	for <lists+ceph-devel@lfdr.de>; Mon, 24 Jun 2019 10:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfFXI5F (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 24 Jun 2019 04:57:05 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38975 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbfFXI5F (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 24 Jun 2019 04:57:05 -0400
Received: by mail-qt1-f194.google.com with SMTP id i34so13631021qta.6;
        Mon, 24 Jun 2019 01:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rwacPTmf68JLKbehPKMF+01ucNGP5jLYN7O/MVkbRZM=;
        b=IaPLALGADm4YigFjf8QaYbqbU8HyByiT2AN/v5LVXIWyOVrJiI9t9HzhqR4sUhgLp6
         pLB7foFEjhs5vdzIPNC3mxdIvK8ao5NriQgLb2pyMc2iYRgnid5GiaSmyf4OpDboLPDT
         oWbySk51XT9RSry1VaGdisjrnH/y3GSDXDXHaJso5IJvP+WcYDZ8mMLhTiKc9Pmp4+ZO
         cZYZh3OTQb01fkp4tOqsJ09A1XX9MRxlapYWHtSLk2EfSOhDn1gq4hB3F4Nn77h7Apl/
         qwr8/3zFKjx6jaHrn47Zxakh9wqSfmsC+ZQyoMqZxAeCNErp6VbGIj7Y8hyy7FlmpBmF
         pTRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rwacPTmf68JLKbehPKMF+01ucNGP5jLYN7O/MVkbRZM=;
        b=RzFFcWqhSfSmbEFG6a1sDe2tnFE2lQcUUhUzEQuUAmX40ObzPwf1eZq6dhVQE0BOa9
         KAlvG9J8AVWsD20F+bQ+ymmUrrVULtO38Iw84euTdG89Wjmnt8p7/oqTX3rnMzKnZyEh
         Kg0boXtyr2zh4Lb4XdTkqa/0ForTvTQplN1XccPD3CmkjM+a7EUIN4ZY8ZHK2lBl6ie8
         0yE+KBXV5v4cZaIOTSjJDpc5zWU9IY3mRBxapFr4TvnkRuGCwbHxM3zyvbX0UZM8vbOv
         XVx0Uy+7KFBjFybh3lP0JI7fc1B43UFedgf3IIqqpHuhgOZ415+kAX6hJzpavubxjX58
         qhBg==
X-Gm-Message-State: APjAAAVARJ9913KDHcIrKOx3syqr2N3DRVZ4iiPASGUPYK6P2zsFFGck
        NUIB/m4fIeoIVKWVfiET4ogQ/o5yu7MXJSyoitY=
X-Google-Smtp-Source: APXvYqzsSuG33IXfavhw36xaFFGbD7fBTgk8QI/l4ZfL7hpDvDTVc+FitqRovMGmS0hsLozqE7DGchEVCY1SYtWJWNU=
X-Received: by 2002:ac8:368a:: with SMTP id a10mr46257196qtc.143.1561366624259;
 Mon, 24 Jun 2019 01:57:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190621141833.17551-1-jlayton@kernel.org>
In-Reply-To: <20190621141833.17551-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Mon, 24 Jun 2019 16:56:52 +0800
Message-ID: <CAAM7YAmfb0ZoaGMqHE8POFbHUFNvzz+eP3Ygsq-ncRptq6wN7w@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] ceph: don't NULL terminate virtual xattr values
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>, agruenba@redhat.com,
        joe@perches.com, geert+renesas@glider.be,
        andriy.shevchenko@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jun 21, 2019 at 10:21 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> v3: switch to using an intermediate buffer for snprintf destination
>     add patch to fix ceph_vxattrcb_layout return value
> v2: drop bogus EXPORT_SYMBOL of static function
>
> This is the 3rd posting of this patchset. Instead of adding a new
> snprintf variant that doesn't NULL terminate, this set instead has
> the vxattr handlers use an intermediate buffer as the snprintf
> destination and then memcpy's the result into the destination buffer.
>
> Also, I added a patch to fix up the return of ceph_vxattrcb_layout. The
> existing code actually worked, but relied on casting a signed negative
> value to unsigned and back, which seemed a little sketchy.
>
> Most of the rationale for this set is in the description of the first
> patch of the series.
>
> Jeff Layton (2):
>   ceph: fix buffer length handling in virtual xattrs
>   ceph: fix return of ceph_vxattrcb_layout
>
>  fs/ceph/xattr.c | 113 ++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 81 insertions(+), 32 deletions(-)
>

Reviewed-by
> --
> 2.21.0
>
