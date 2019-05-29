Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D2E2E85B
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2019 00:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfE2Wfq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 29 May 2019 18:35:46 -0400
Received: from mail-qk1-f178.google.com ([209.85.222.178]:38141 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfE2Wfq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 29 May 2019 18:35:46 -0400
Received: by mail-qk1-f178.google.com with SMTP id a27so2595183qkk.5
        for <ceph-devel@vger.kernel.org>; Wed, 29 May 2019 15:35:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=oVbGOacaSjCrjTOEtrEuRh9IpviX4Az1xyxUGdt2p5g=;
        b=Oga4O9HsH6gTmhgddLa6Q6nIT7E9C7cShrJgld7TtLRrUlwdUfmeU0QOkxX0kPylcA
         yfdjLJHA+C/JiBtXZuET9OAIZx3D9BsyUj5asIIoeM2L8b2uFXFDxZlYQ1iwooMhwzSi
         MUDB/9n3pl2H6dGoEvxv93qfyI3TI/klTMJ59FUWJb23VHJdrkQAtDgWJHka50oDg9D5
         ojWqW4vyUQZHnLzrUUwj9Vy+BPuvqp28/fdZss6UaKBv5RyWDbJd8cqIiTHjWfaaiQJN
         /n42XVYNwUbzSEitjKlDS9x4LO+m3PXm+8FWKnheLv5mUqYYtVIQMGD9S4pUXM+qL1B3
         piWA==
X-Gm-Message-State: APjAAAWHJrFCaT/vVcaP4BfyHKwVqtWbgY6BR0V/OQsiYkcv26uxfLXM
        Z81lJB0aCVshacLkCDDd6DKqUg2KtGdoYYu5NngB+g==
X-Google-Smtp-Source: APXvYqxZh6pYddI5y/vWycho/1a5kDSc97CnFuDCsbeWB3I1ZFEQlazqVFnALcvyeSQH2N2/I99NkgphtcP747mlTes=
X-Received: by 2002:a37:ad0b:: with SMTP id f11mr254182qkm.25.1559169345627;
 Wed, 29 May 2019 15:35:45 -0700 (PDT)
MIME-Version: 1.0
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Wed, 29 May 2019 15:35:19 -0700
Message-ID: <CA+2bHPYr23dj0y1q7gKjh+WdRiWmJd+zZi4rsPOxDLBAXMFZOw@mail.gmail.com>
Subject: Sunsetting ceph_volume_client.py
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

Ramana,

With the ceph-mgr volumes plugin becoming the official means to create
volumes for cephfs, we need to plan to sunset ceph_volume_client.py.

Part of that means turning off testing the ceph_volume_client.py
library for clients running on master (for Octopus) but still testing
clients running an older version like Mimic/Luminous/Nautilus. Testing
ceph_volume_client.py in master is no longer productive as python3
movements are breaking it continuously and it's to be obsoleted in
Octopus. Testing ceph_volume_client.py on an older client remains
important as we're aware of at least one failure caused by `mds dump`
being obsoleted by Nautilus. Also, we don't want to break current
use-cases that are not ready to migrate to the new volumes plugin.

So we need an upgrade test in qa/suites/fs/upgrade/ that does this
testing. That will mostly be migrating the existing test in
fs/basic_functional/tasks/volume-client to an upgrade test. The tricky
part is installing luminous on the client machine and then configuring
it to talk to the Nautilus/Octopus cluster. Up to now, we normally do
testing of old clients by first setting up the cluster with the older
version we like to test and then upgrading every node except the
clients. This won't work anymore (easily) because we no longer can
upgrade directly from Luminous to master/Octopus. So, we need to get a
little smarter by simply installing luminous packages on a client node
and then installing a ceph.conf to talk to the Nautilus/Octopus
cluster. +Josh suggested that we could split out the function setting
up the ceph.conf in qa/tasks/ceph.py into a separate task that can be
run on the clients. It does need to be made a little smarter so that
it installs a ceph.conf that is readable by a luminous client. In
particular, it can't dump v2 monitor addresses to the ceph.conf.

What do you think?

--
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
