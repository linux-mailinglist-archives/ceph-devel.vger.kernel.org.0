Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 890E52E96B
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2019 01:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfE2Xci (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 May 2019 19:32:38 -0400
Received: from mail-qk1-f177.google.com ([209.85.222.177]:45141 "EHLO
        mail-qk1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfE2Xci (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 May 2019 19:32:38 -0400
Received: by mail-qk1-f177.google.com with SMTP id s22so631541qkj.12
        for <ceph-devel@vger.kernel.org>; Wed, 29 May 2019 16:32:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PvapoXnx01ioeCgV4gogc69NPNXKAPH0vutV8gkSol8=;
        b=FLwVEP6aEYXFGfNxSKUvRJwRvpPiFG9vi/jvdJNjb3ACwt/daGj4TPTp1PIO6vwYY5
         407GiAdRYvJ8WIMbWUtgwSUG7s8grOZaNl4eWXwxBbJm9hRv4RKF/X7drZw0gVtu7s9T
         xjwb9VPeqXMV7VMiF5OaBym7vm7529PPR7WlwNKzK7ajw+JIaoKJWMOE5jmBofF/4NrH
         Z1pelh1ufSO0MsRdyRgi7VaoDthQmmr5oGLDhGc4QNsaPWDwWKiEzvhqgLVeK/+9A3Ng
         43bQmsBuEDsxpWHMTcTGh4q2XRgjFZdofabOonuIwTdX+34Qa1rXhcYzGzYlwZJWDy5y
         7UUQ==
X-Gm-Message-State: APjAAAU6odnVP4Isfz0VUf4gzzVg/yObOMcF9Tx3ILqnV6E5fvcNDzUl
        rqFZ9w5/AXGSyrROSz8wsewjf1V+9shlBjoOXQKd/w==
X-Google-Smtp-Source: APXvYqwq4/wFDzabeywdDJPaA+QpuhznFfeuaVDVW9yJn3xvLwvAT7T//Cw8Efv6lTI1TVpnz8Jg2CKzCklzC1m/arw=
X-Received: by 2002:a37:a743:: with SMTP id q64mr460911qke.236.1559172757000;
 Wed, 29 May 2019 16:32:37 -0700 (PDT)
MIME-Version: 1.0
References: <CA+2bHPYr23dj0y1q7gKjh+WdRiWmJd+zZi4rsPOxDLBAXMFZOw@mail.gmail.com>
In-Reply-To: <CA+2bHPYr23dj0y1q7gKjh+WdRiWmJd+zZi4rsPOxDLBAXMFZOw@mail.gmail.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 29 May 2019 16:32:10 -0700
Message-ID: <CA+2bHPa3JXuVBf4owNz302SJY9kigzOPkYmWoZjcNjz39pbOTg@mail.gmail.com>
Subject: Re: Sunsetting ceph_volume_client.py
To:     Ramana Venkatesh Raja <rraja@redhat.com>,
        Rishabh Dave <ridave@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Sage Weil <sweil@redhat.com>, Josh Durgin <jdurgin@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 29, 2019 at 3:35 PM Patrick Donnelly <pdonnell@redhat.com> wrote:
> So we need an upgrade test in qa/suites/fs/upgrade/ that does this
> testing. That will mostly be migrating the existing test in
> fs/basic_functional/tasks/volume-client to an upgrade test. The tricky
> part is installing luminous on the client machine and then configuring
> it to talk to the Nautilus/Octopus cluster. Up to now, we normally do
> testing of old clients by first setting up the cluster with the older
> version we like to test and then upgrading every node except the
> clients. This won't work anymore (easily) because we no longer can
> upgrade directly from Luminous to master/Octopus. So, we need to get a
> little smarter by simply installing luminous packages on a client node
> and then installing a ceph.conf to talk to the Nautilus/Octopus
> cluster. +Josh suggested that we could split out the function setting
> up the ceph.conf in qa/tasks/ceph.py into a separate task that can be
> run on the clients. It does need to be made a little smarter so that
> it installs a ceph.conf that is readable by a luminous client. In
> particular, it can't dump v2 monitor addresses to the ceph.conf.

Adding on to this:

Sage thinks we can just do the install luminous task on all nodes and
then install.upgrade on everything but one of the clients. Finally,
run the ceph task on all the nodes but add a few options to only use
the v1 addresses so that the ceph task doesn't put a ceph.conf with v2
addresses on the client node. See also rados/thrash-old-clients.

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
