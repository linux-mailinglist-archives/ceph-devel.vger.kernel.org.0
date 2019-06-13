Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6543343ABE
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jun 2019 17:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731899AbfFMPXP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Jun 2019 11:23:15 -0400
Received: from mail-qt1-f175.google.com ([209.85.160.175]:45529 "EHLO
        mail-qt1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731884AbfFMM3u (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Jun 2019 08:29:50 -0400
Received: by mail-qt1-f175.google.com with SMTP id j19so22237017qtr.12
        for <ceph-devel@vger.kernel.org>; Thu, 13 Jun 2019 05:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QNdYssO9STOc43hmt/09DWyChU6v8W5SzuXEJ9Mf7Gw=;
        b=FW/RZ7Pmi7J3CspVfTz2abYgsFZShz+UvGCXdKAn68NzaLAzKFS+stXjMHcsPL+hRd
         QROwNzZapqxvEV6VXZmIW5hqzedj1yRQcSXKIbppspTrG4awWZR0yoOoKcQnSMW30Kj+
         hWGlH/rpuIBiB1jPMf++N1BamMFEmOukIAiFUuA+XrpbhhGNlXL9vWKNQbJB134PATRY
         buKDFW4PdKgFei24vlCHbhSprvdkxZXVsntu6Fi2OHspz3k7XZMpKlnd3qHax9DfP63Q
         ZhxIqlI7JEHy7jMXBINNT23yua17bdnbGdQy+el/Hlcul0/mbdOYPTIAantcH2y718uU
         kUng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QNdYssO9STOc43hmt/09DWyChU6v8W5SzuXEJ9Mf7Gw=;
        b=N//x9dW5GNzGOZ7RBz5BsuioSEem8u5G5qjWT1rYWmYilslR9Rv07Mzkcd3xefvwlF
         5Gu6j7Qh4j4I6a937yQ5YwJ7rFb7SXBC+MMQacSJcLqz3SehknIcAnZ8UCAtpXYdr9rK
         gVKj6OLzPiqvG312rNtoxOAQ+++m2fbqNf8MA4TyI7ccS6Wb+NsAYRwyKtYG7eOFEmPC
         JJUFRQqpag7L8bowtTHN5isbSKiZhEIxT5gBcjKY+AId5irMpCxwTFr0tYWGjZ92zJA0
         ED9MbvXjJRt3E0JdGLVV7BMNcii/V5m17c8E6e+TvuahL/FBAQDGQC5Y0GTbUm/u9BoF
         RnXQ==
X-Gm-Message-State: APjAAAU70z+QMWydiu38+fCI65PgrKCDlu66Qg5xblrWN2p5LfDeU9B1
        an297Wz4ISCbZEI2BrUIQTEquqcJPh0SLSBDVvc=
X-Google-Smtp-Source: APXvYqxv6TKh6RsbrtRVoVilvv8vG7RxGZxcB4634yQxnVZB6IISxqO7+fQz0ytlMisiLsZghHQ/19shqqvbRw9fgFY=
X-Received: by 2002:ac8:87d:: with SMTP id x58mr75800322qth.368.1560428989724;
 Thu, 13 Jun 2019 05:29:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAJACTucBQKTh-NxM2M_=JbbczrfomR75W0y8xjHS3DPaqn9XaQ@mail.gmail.com>
In-Reply-To: <CAJACTucBQKTh-NxM2M_=JbbczrfomR75W0y8xjHS3DPaqn9XaQ@mail.gmail.com>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 13 Jun 2019 20:29:38 +0800
Message-ID: <CAAM7YA=c9sHcHepRop71tiwFnXr5twrPWfsMJpt=UzZ2fU_CDA@mail.gmail.com>
Subject: Re: Should client dirty caps flush be enclosed in rstat propagation operations?
To:     Xuehan Xu <xxhdx1985126@gmail.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        Sage Weil <sweil@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jun 12, 2019 at 9:52 AM Xuehan Xu <xxhdx1985126@gmail.com> wrote:
>
> Hi, zheng and patrick.
>
> During the last CDM, you mentioned that before doing rstat
> propagation, client dirty caps should be forced to flush after taking
> snapshots and before doing rstat propagation. Do you think that
> forcing dirty caps flush should be enclosed in the rstat propagation
> operation or be another stand-alone operation? Thanks:-)

I prefer stand-alone operation.

Regards
Yan, Zheng
