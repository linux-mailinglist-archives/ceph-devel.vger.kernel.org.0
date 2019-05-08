Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E12A18169
	for <lists+ceph-devel@lfdr.de>; Wed,  8 May 2019 23:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfEHVAN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 May 2019 17:00:13 -0400
Received: from mail-it1-f175.google.com ([209.85.166.175]:53069 "EHLO
        mail-it1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725910AbfEHVAN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 May 2019 17:00:13 -0400
Received: by mail-it1-f175.google.com with SMTP id q65so6458093itg.2
        for <ceph-devel@vger.kernel.org>; Wed, 08 May 2019 14:00:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3+eL5w5ZAJjJCascO5Y3njh3f77hofKNt5Ixm39/Tzg=;
        b=ejQkLGd1Tr+Y1fn9nxr1McdRvy3qo7i2eBwu4fC33mXRPvDhkGzlu0QnEY/68N04/L
         QLKeZvKz4vYMHco6h+Qxv6cQflFQLQhFINmpgjjmZL2OZm9yDZrFk3ggN2Fb3SV9S+kY
         Gx2uO+UP/q4A/b0oI51Z0B/0FOYaAPppYL999RE0oKRe9kNN5Kj1XqnxKyFcLSve0NgH
         9tgU4fpRPJtK5ilnasE4A750VqAovUQGXKUeqNjqwmeNGEgGCOZ/3nYjJWh+NbronpyV
         L2/wg50Qc89OoV7fc78QDv9uM3YkBzkVNni1ffWTBfw3cfUOKC9W++6e5NDbuO5Mv3fn
         geSw==
X-Gm-Message-State: APjAAAWVM9CnNyphJ8aWvlxQ0XPt7WQB6yPY7U+hEhxoqGn7ImfK4LBi
        lEwZZGR8evwTXIrdUXeFld2UWPfRdljBD5S9qELGzw==
X-Google-Smtp-Source: APXvYqwTe8VOxcLk/mBztB8Dg8pEwS1segryycDYhyx0sChEVVMeVF/D3T/OeckXprT/86VYzJ+lyq0Y+wmOlAMQn4s=
X-Received: by 2002:a02:c6d8:: with SMTP id r24mr77695jan.93.1557349212083;
 Wed, 08 May 2019 14:00:12 -0700 (PDT)
MIME-Version: 1.0
References: <CALi+v1_fTKgpKtMTBDw3ioy4SqtsvP3xkjXLyLX5Gb=_7yoaNg@mail.gmail.com>
In-Reply-To: <CALi+v1_fTKgpKtMTBDw3ioy4SqtsvP3xkjXLyLX5Gb=_7yoaNg@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Wed, 8 May 2019 13:59:47 -0700
Message-ID: <CAJ4mKGaRZrA9P6=hZ+CZ7oca5_b9uGXZAV5gNu2YiNajy1q8Qw@mail.gmail.com>
Subject: Re: some questions about fast dispatch peering events
To:     zengran zhang <z13121369189@gmail.com>
Cc:     Sage Weil <sweil@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 8, 2019 at 6:12 AM zengran zhang <z13121369189@gmail.com> wrote:
>
> Hi Sage:
>
>   I see there are two difference between luminous and upstream after
> the patch of *fast dispatch peering events*
>
> 1. When handle pg query w/o pg, luminous will preject history since
> the epoch_send in query and create pg if within the same interval.
>     but upstream now will reply empty info or log directly w/o create the pg.
>     My question is : can we do this on luminous?

I think you mean "project history" here?

In any case, lots of things around PG creation happened since
Luminous, as part of the fast dispatch and enabling PG merge. That
included changes to the monitor<->OSD interactions that are difficult
to do within a release stream since they change the protocol. We
typically handle those protocol changes by flagging them on the
"min_osd_release" option. We probably can't backport this behavior
given that.

>
> 2. When handle pg notify w/o pg, luminous will preject history since
> the epoch_send of notify and give up next creating if not within the
> same interval.
>     but upstream now will create the pg unconditionally, If it was
> stray, auth primary will purge it later.
>     Here my question is: is the behavior of upstream a specially
> designed improvement?

My recollection is that this was just for expediency within the fast
dispatch pipeline rather than something we thought made life within
the cluster better, but I don't remember with any certainty. It might
also have improved resiliency of PG create messages from the monitors
since the OSD has the PG and will send notifies to subsequent primary
targets?
-Greg
