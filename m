Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17764368D0
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 02:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfFFAlf (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Jun 2019 20:41:35 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:36490 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726543AbfFFAlf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Jun 2019 20:41:35 -0400
Received: by mail-ot1-f65.google.com with SMTP id c3so387175otr.3
        for <ceph-devel@vger.kernel.org>; Wed, 05 Jun 2019 17:41:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=am4WLHp9xrxf4DOS7QyFjisSOee+5+vugEPX9u0qS2M=;
        b=tG2/IH8zDatHAdl0H9L3Dp7FRu1XfVVp90ykO4FdtMBagXcXSeP1a9Yig+y1N1ZsHZ
         cWOgkrFMAwgI83xvEZMNZSjzIqZTng2NpdTEbBwbkx0qvt3V4DaBHW/5W3fYeUWaLGQ0
         EiDQ4tSypeBatkE1WezmWAbqQTVHJWYE1dwogZcka9MI1ZHCBl01cpOg53loUwiIOGzF
         KcaBd7pG0VVZxwYcViJaZ3BGmLYrr61/RZsXzWWBaiIyV+lCchn7TltEeAj6N4ceO6PA
         IdyUAoezSEWTa/IYcqEJsg3iK8O5u9x9JlT5dzglL3bIwbZkoOOMdu1DOHcXcY8zprch
         DDHg==
X-Gm-Message-State: APjAAAU0VSJzgBw3u4y8wXttCrr/nBzlsQVY51xS9gxfSG99SJAOyHyk
        eEOXglrI1F4hF3sRCrVj3XmUcLiZKsHpYCwNJVzCaA==
X-Google-Smtp-Source: APXvYqx7cPLr/dHDXqhOWWfQl9UptMv3V49A7C0edoAorA1ou2DqUuHEnZxHnoHnDgPUbPcWOY/5NsSVCcRkOwMOaoo=
X-Received: by 2002:a9d:6499:: with SMTP id g25mr12027770otl.184.1559781694654;
 Wed, 05 Jun 2019 17:41:34 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.DEB.2.11.1906041512530.22596@piezo.novalocal>
In-Reply-To: <alpine.DEB.2.11.1906041512530.22596@piezo.novalocal>
From:   Vasu Kulkarni <vakulkar@redhat.com>
Date:   Wed, 5 Jun 2019 17:41:24 -0700
Message-ID: <CAKPXa=amArp-MWzTvuRS13H78GkmO8WZ2G6Ho7Ekq-hv6N1xJQ@mail.gmail.com>
Subject: Re: ANNOUNCE (take 2): dev@ceph.io and ceph-devel list split
To:     Sage Weil <sweil@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 4, 2019 at 8:18 AM Sage Weil <sweil@redhat.com> wrote:
>
> Hi everyone,
>
> We are splitting the ceph-devel@vger.kernel.org list into two:
>
> - dev@ceph.io
>
>   This will be the new general purpose Ceph development discussion list.
>   We encourage all subscribers to the current ceph-devel@vger.kernel.org
>   to subscribe to this new list.
>
>   Subscribe to the new ceph-devel list now at:
>
>     https://lists.ceph.io/postorius/lists/dev.ceph.io/
After registration, email is not being sent(checked all folders too),
Anyone else seeing this?

>
>   (We were originally going to call this list ceph-devel@ceph.io, but are
>   going with dev@ceph.io instead to avoid the confusion of having two
>   'ceph-devel's, particularly when searching archives.)
>
> - ceph-devel@vger.kernel.org
>
>   The current list will continue to exist, but its role will shift to
>   Linux kernel-related traffic, including kernel patches and discussion of
>   implementation details for the kernel client code.
>
>   At some point in the future, when all non-kernel discussion has shifted
>   to the new list, you might want to unsubscribe from the old list.
>
> For the next week or two, please direct discussion at both lists.  Once a
> bit of time has passed and most active developers have subscribed to the
> new list, we will focus discussion on the new list only.
>
> We will send several more emails to the old list to remind people to
> subscribe to the new list.
>
> Why are we doing this?
>
> 1 The new list is mailman and managed by the Ceph community, which means
>   that when people have problems with subscribe, mails being lost, or any
>   other list-related problems, we can actually do something about it.
>   Currently we have no real ability to perform any management-related tasks
>   on the vger list.
>
> 2 The vger majordomo setup also has some frustrating features/limitations,
>   the most notable being that it only accepts plaintext email; anything
>   with MIME or HTML formatting is rejected.  This confuses many users.
>
> 3 The kernel development and general Ceph development have slightly
>   different modes of collaboration.  Kernel code review is based on email
>   patches to the list and reviewing via email, which can be noisy and
>   verbose for those not involved in kernel development.  The Ceph userspace
>   code is handled via github pull requests, which capture both proposed
>   changes and code review.
>
> Thanks!
