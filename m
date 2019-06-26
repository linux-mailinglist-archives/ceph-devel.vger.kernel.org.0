Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2D455EE4
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jun 2019 04:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfFZCgR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Jun 2019 22:36:17 -0400
Received: from mail-ed1-f49.google.com ([209.85.208.49]:41235 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfFZCgR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Jun 2019 22:36:17 -0400
Received: by mail-ed1-f49.google.com with SMTP id p15so891498eds.8
        for <ceph-devel@vger.kernel.org>; Tue, 25 Jun 2019 19:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=jN7N61BR/DzVvdxgatEurOFZVklqxZsgnl4z0zPRqAI=;
        b=CYupX0nkC5AmoO9BbVMCq53p5aTY18JUgW78KJiAEYGl2ThAoAn/oIvdgy7hHdvpJq
         uh4zVj6DJEiCVrewNwC3ZYUXVJq8Yn/f0PsgUVNWtXBUgfl8DK/0ZLTOE9gHWfdLn/pj
         K90W0SBICdcp1g4seg8peABOnXeHnJEY2htP07k/+TqYBMWAywpXBKqXVgybIDgFkHYe
         6hmYRSAw04gq7ZqErHb/GWuXm3XIWzptlJMK6Z2yYhCI0e3aCXarux5ldYMj5hsKcKpk
         HBDrsgUr1JITeCOYHx5gkEgvb1xXmvhxnFuwdOAF3Hrj7fSFNonfqBkpxsrxAuDKLVYb
         qvQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=jN7N61BR/DzVvdxgatEurOFZVklqxZsgnl4z0zPRqAI=;
        b=GlFkFpS7ww1rI5JRN0ruW0WXcnRvZzlCvVwECOgUmh2BQj1891jChPa10pLh6UCOV5
         50/u2F3qsj0uNBQJyc4kR/Gp3qzQCFX0sSKQL7LB1ZS0/Zp6VaQENJFZzMhEB6wTNarl
         BoQQs92WeyEDoCWQARgIQwb8H64m5oATelRKcm+VAteUGW+HIZu+V1jliKZZVOdbWCTj
         FA5CRaIlllCVTKsCBadgC07hZK8NncxTM1mtZnyDjmygGFwOcvD8+/kUJDVsFWvtRjZG
         PNKfgGqGPczXWHH2YzFvbEMvRdkXUniMB8FQEvgM+5tGZgNfkYeQcXrNGLqowqASPenH
         Dn3A==
X-Gm-Message-State: APjAAAUHl1SExJAhm5qbYZv7Qy6ha2JjOErQuvsvkt8AZXa/sIjlza2o
        v35UnpMiFRdGv4KG6SjQD8bti2+BMyEU8mr+2x+nfvZy
X-Google-Smtp-Source: APXvYqzSD5TSZ6sN8pk2BYPIDoCppQ30hPpyAl/VjJTs0BKkLxPPQEkybK046OxiqHUeYr3L3KRJjyychDxrV6ZXFX8=
X-Received: by 2002:aa7:c313:: with SMTP id l19mr2025220edq.258.1561516575534;
 Tue, 25 Jun 2019 19:36:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAGgPxMfzfvKQuqmUuO32jNpAnWr0j66J74hm1rq18A0M1dB2zg@mail.gmail.com>
In-Reply-To: <CAGgPxMfzfvKQuqmUuO32jNpAnWr0j66J74hm1rq18A0M1dB2zg@mail.gmail.com>
From:   Tony <yaoguot@gmail.com>
Date:   Wed, 26 Jun 2019 10:35:53 +0800
Message-ID: <CAGgPxMcwsxbZRwjOgx1FDjF2SSFTxq6Oxu+D-=HmEpotFJvg3g@mail.gmail.com>
Subject: rbd exports do not use the object-map feature
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi all,

Recently, I have been studying the influence of object-map on RBD export .
My expectation is that object-map can improve the speed of export

But, I did not find any effect of object-map in the experiment.  Then,
I look in the code for the reason.
I found that the object-map was ignored when rbd opened the image in
read-only mode,
and Open image read-only when export.

I'm wondering why we can't open an image in read-only mode using
object-map feature.
In this case, the object-map feature does not seem to improve the
performance of rbd export .

Your prompt reply will be appreciated.
Thanks.

Guotao Yao
