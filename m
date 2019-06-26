Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9B685693D
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Jun 2019 14:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfFZMdK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Jun 2019 08:33:10 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:32816 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfFZMdK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 26 Jun 2019 08:33:10 -0400
Received: by mail-ed1-f50.google.com with SMTP id i11so3162933edq.0
        for <ceph-devel@vger.kernel.org>; Wed, 26 Jun 2019 05:33:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=yhlhQFspDmxCrHBv9HH/5gC/OxtfpmUsCpkjWjyc7GU=;
        b=YqyuuGuUdlaO7uDW4BtkhUyTdemEob8/ExL+NcaV+nptJ9yzKO0gMLXObS9V+esWf3
         36rab9C/H3gnMATmeSqWEEBHBZhw6oXy0UJqHYcw4qZX5wgLwRiyMwSucsWA8t8rVuyM
         k+Cgx+g4sMp/sYVgDyfFaRh/0sSz6s1QkALEzhgK+rezqtT88473YP3w6w3SiAZpkJ1e
         d0nuUQuBB2sXiLBt3Gj+kqnmKFd4+Nwjp2X5orrRiYkhDt74vaxmDGQPst5XVNgNmrdN
         KE2HYizYgA1ukcC+uE40SHHH/SivRCknEhPeHeY2G+tdyYmS1cPcR890UBHH5fiOtk3g
         3btA==
X-Gm-Message-State: APjAAAWozVcy1R1ExkPhJ2gKBxwT3VxNVOweg3ZXoALcJ7lEDSqCQ5eU
        kfru1xHyNN/Q/+JUqZ5e/hLw4rR5LNqlmzPVa9bbNA==
X-Google-Smtp-Source: APXvYqwSUTBIyzHohWfnuTS6vQRVtvmic16VrREl2QCNJjYdWFqjIaT7aRgdNZOxJsjk0V4v3h8JweN51TPOa6QvI6o=
X-Received: by 2002:a05:6402:12d2:: with SMTP id k18mr4802201edx.197.1561552388508;
 Wed, 26 Jun 2019 05:33:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAGgPxMfzfvKQuqmUuO32jNpAnWr0j66J74hm1rq18A0M1dB2zg@mail.gmail.com>
 <CAGgPxMcwsxbZRwjOgx1FDjF2SSFTxq6Oxu+D-=HmEpotFJvg3g@mail.gmail.com>
In-Reply-To: <CAGgPxMcwsxbZRwjOgx1FDjF2SSFTxq6Oxu+D-=HmEpotFJvg3g@mail.gmail.com>
Reply-To: dillaman@redhat.com
From:   Jason Dillaman <jdillama@redhat.com>
Date:   Wed, 26 Jun 2019 08:32:57 -0400
Message-ID: <CA+aFP1BtF+1BBH42-EF82U2oNG0OFF72j6ywoaKCfRfcCKwe0w@mail.gmail.com>
Subject: Re: rbd exports do not use the object-map feature
To:     Tony <yaoguot@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 25, 2019 at 10:37 PM Tony <yaoguot@gmail.com> wrote:
>
> Hi all,
>
> Recently, I have been studying the influence of object-map on RBD export .
> My expectation is that object-map can improve the speed of export
>
> But, I did not find any effect of object-map in the experiment.  Then,
> I look in the code for the reason.
> I found that the object-map was ignored when rbd opened the image in
> read-only mode,
> and Open image read-only when export.
>
> I'm wondering why we can't open an image in read-only mode using
> object-map feature.

It's because the HEAD revision of the image is still mutable and you
don't have any assurances that it isn't being modified in the
background. If you take a snapshot and export the snapshot, the
object-map will be used since the snapshot content is immutable.

> In this case, the object-map feature does not seem to improve the
> performance of rbd export .
>
> Your prompt reply will be appreciated.
> Thanks.
>
> Guotao Yao



-- 
Jason
