Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D950FBD346
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Sep 2019 22:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633098AbfIXUFs (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 Sep 2019 16:05:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36996 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728405AbfIXUFs (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 24 Sep 2019 16:05:48 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DDD5BC057F31
        for <ceph-devel@vger.kernel.org>; Tue, 24 Sep 2019 20:05:47 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id m19so3306388qtm.13
        for <ceph-devel@vger.kernel.org>; Tue, 24 Sep 2019 13:05:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E4regRNVO3vjgMaoXNbC5zaN4cX4bMmKQcG81nsWQsQ=;
        b=Dag5UsNp2DU5dKTdVsSCWZfoYCZ/FLCndhcwsNvy/G0Pqh28c41qoWy80yZxfui3cy
         eTH0EbAyh2vua/pVVks3Po5Pv9CGusG6b/HqIjSAJQloNiIu9k8SWKnxvMQZ0OIpdG3Z
         S/n6sFxcYfA+vxOPHnEFrkbkZA47+NIjRdzRC5koU61AuOl0yFE4BZWBzdlWOubpHgM0
         DgE/F6NmgPpsiaz4yj8Q2ocEUWJm3/k4R7FCdSow7LTeu8Tea/4SgXObL73Y9Rhd0m1a
         Y6/BErkvuHMfMl5BbSjBxfychGrHgGGd2WC21ORlYQ8ljo/RlHrIJ5RUAnQ26be05WA3
         Cv3A==
X-Gm-Message-State: APjAAAVnqhjnQ8ouzm6qfHVJm5z8E3t0AotrY6e0roO3gY9fKL4vd0Np
        4NlXz3PKjoEraPcihvKfaciHKla3NBLJJpSebIpJMu81hwtpIkD2wLJthIj67b+mwLUklhSkvLX
        1q/flQcYxO5D+YeQZzsuw2iL3mJaGVsHDE3VE7g==
X-Received: by 2002:ac8:340d:: with SMTP id u13mr4783974qtb.103.1569355547219;
        Tue, 24 Sep 2019 13:05:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzI3xB6n/sb1QWt5Wu7pfEbNA7rXtqPVwcW84UJmUNsLo5n0p0Il1YF24qXTIPCnWrZx2tl2RWkeENKHgi1tGk=
X-Received: by 2002:ac8:340d:: with SMTP id u13mr4783962qtb.103.1569355546993;
 Tue, 24 Sep 2019 13:05:46 -0700 (PDT)
MIME-Version: 1.0
References: <CAC-Np1zTk1G-LF3eJiqzSF8SS=h=Jrr261C4vHdgmmwcqhUeXQ@mail.gmail.com>
 <CAC-Np1zjZJW2iqLVe720u_sxQDTKjoUqL9ftrqKbMcYbZQgYFQ@mail.gmail.com> <CALi_L4_Sz8oFHAFyRfqDfLWGRJSHnSd=dyYUZ6P92o8VY3vGCQ@mail.gmail.com>
In-Reply-To: <CALi_L4_Sz8oFHAFyRfqDfLWGRJSHnSd=dyYUZ6P92o8VY3vGCQ@mail.gmail.com>
From:   Ken Dreyer <kdreyer@redhat.com>
Date:   Tue, 24 Sep 2019 14:05:36 -0600
Message-ID: <CALqRxCygXUzA0+4sY6meMO9Smq2rouei7ay0BqJD9+-du7RCYQ@mail.gmail.com>
Subject: Re: [ceph-users] Re: download.ceph.com repository changes
To:     Sasha Litvak <alexander.v.litvak@gmail.com>
Cc:     Alfredo Deza <adeza@redhat.com>, ceph-maintainers@ceph.com,
        ceph-users <ceph-users@ceph.io>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Sep 17, 2019 at 8:03 AM Sasha Litvak
<alexander.v.litvak@gmail.com> wrote:
>
> * I am bothered with a quality of the releases of a very complex system that
> can bring down a whole house and keep it down for a while.  While I wish the
> QA would be perfect, I wonder if it would be practical to release new
> packages to a testing repo before moving it to a main one.  There is a
> chance then someone will detect a problem before it becomes a production
> issue.  Let it seat for a couple days or weeks in testing.  People who need
> new update right away or just want to test will install it and report the
> problems.  Others will not be affected.

I think it would be a good step forward to have a separate "testing"
repository. This repository would be a little more cutting-edge, and we'd copy
all the binaries over to the "main" repository location after 48 hours or
something.

This would let us all publicly test the candidate GPG-signed packages, for
example.

- Ken
