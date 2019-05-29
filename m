Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC4B2E4D0
	for <lists+ceph-devel@lfdr.de>; Wed, 29 May 2019 20:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfE2SwH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 May 2019 14:52:07 -0400
Received: from mail-it1-f176.google.com ([209.85.166.176]:35497 "EHLO
        mail-it1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfE2SwH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 May 2019 14:52:07 -0400
Received: by mail-it1-f176.google.com with SMTP id u186so5336499ith.0
        for <ceph-devel@vger.kernel.org>; Wed, 29 May 2019 11:52:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5B5nI2uiCAEW6VDoTrNsIrk4yKSKlI1UxAatdWqgq2k=;
        b=scZuqOr7CEuLOqHe1u/czExadXfCgBI/sH+aRD3tQp3UDS5Dt+3uGUvqJZK2lHv+Bo
         iA0zfMc0kYhbekchLdlDXRmzvZ8CHs5K4Uam/y4YE7PiFVa8k9+38OJwZhKHbzVdKBs+
         OUgHTNATftYGnhf4XjpNH3ekP3bL+toxJAiFK86qELMDfJRobmtvpzrMsm5xQ5irzZvL
         vZqEUKvn9Vkk9sG4H+DRuIgk78qpcjqmmpikzFpOe0xRx84Nd4mEORCNkWHyrSd+XK+w
         YnBiDLvC4dSXk2PhfGthyNMa2cz5yN5oxGC20eSBmvfZ/eoVj6SfpyAtJp9LwoEOTjj1
         FPZw==
X-Gm-Message-State: APjAAAXDrcnsGzJncGukdC0tkPVpc3AB1IRw+DroUqgx+qmIIO+AJsnj
        ON18Oz3RM2iYzHC4TYFQI7wH3vAmb5/rOqINNJM2zQ==
X-Google-Smtp-Source: APXvYqxTwKCCNCe2fA5vkRFn/09HRaygOsvbge2AXf4KiwSw+FW6I/KDNYm59zn/TQk0ZogzLITejOpYdB6oZVmu9Xw=
X-Received: by 2002:a24:104a:: with SMTP id 71mr8588476ity.76.1559155926417;
 Wed, 29 May 2019 11:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAED=hWDkQngRnF=mO_hiAyPSV5tAeSN7JgwjOQBXbwo-_d-WNw@mail.gmail.com>
In-Reply-To: <CAED=hWDkQngRnF=mO_hiAyPSV5tAeSN7JgwjOQBXbwo-_d-WNw@mail.gmail.com>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Wed, 29 May 2019 11:51:27 -0700
Message-ID: <CAJ4mKGb4+KFYQ1CQAid18u_kaiv=2Ait0mevFVQtyNGPfusOKA@mail.gmail.com>
Subject: Re: When to use RadosStriper vs. Filer ?
To:     Milind Changire <mchangir@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 17, 2019 at 12:24 AM Milind Changire <mchangir@redhat.com> wrote:
>
> The idea is to use sqlite3 to work around the disk size constraint for
> individual objects and/or their attributes (key-value pairs) so that
> the Ceph implementation can manage/stripe the underlying data blocks
> across OSDs seamlessly.
>
> The implementation would be an sqlite3 VFS back-end interface to Ceph.
> eg. metadata server (MDS) could create an sqlite3 database using this
> new back-end to manage objects spread across OSDs
>
> So, do I use the RadosStriper or the Filer class for the implementation ?
>
> Or, do I need to tweak current implementation of some class(es) to get
> the desired functionality in place to be used in the sqite3 VFS
> interface implementation.

It's not clear to me exactly what functionality you're looking for to
plug into the sqlite backend.

I will say that the Filer, messy though it can be, is used extensively
by CephFS and by the RBD mirroring functionality, whereas RadosStriper
was contributed (from CERN?) as part of a specific "lite rados FS"
concept and is mostly orphaned AFAIK.
IIRC the RadosStriper may also go to some effort to try and keep the
striping objects consistent across multiple accessors, whereas the
Filer assumes a higher layer is dealing with that.
-Greg

>
> --
> Milind
