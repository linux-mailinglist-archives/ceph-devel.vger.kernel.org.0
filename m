Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8A7448D4
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jun 2019 19:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729381AbfFMRLd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Jun 2019 13:11:33 -0400
Received: from mail-io1-f52.google.com ([209.85.166.52]:33778 "EHLO
        mail-io1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729108AbfFMRL0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 13 Jun 2019 13:11:26 -0400
Received: by mail-io1-f52.google.com with SMTP id u13so18619407iop.0
        for <ceph-devel@vger.kernel.org>; Thu, 13 Jun 2019 10:11:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=0sNq50K3w/FYdPxN04caCJ8/UkqtCpsagERPlxRrA3o=;
        b=V6sK9sdyv13lwtqzEv4Q1PPozqqEODiAeDG0ryYyGOl0zysmUnNC4ZzZOufNU7U1pH
         fTDMCmv3xjnOnEoCCD9mnhyoTdsLf2B55kovFHUQ07zZwHD7XSUQiO0Htebtvup2eDRT
         D4l/vJY3r/84gwezD9tifcXHxAdfRT96vuw0FzL6rijUK6/psKvK8lJNgHzrYO6kg/+v
         2Faez+XCsaeOkvET/FOUSzYfMjd4b0Rf01Jgwv4bjwA0KN3LUiOer3T5TDGE/+kJKib9
         rcuYU/85deSkqfRoCOWi2e77+BYY2lsLkKj+0MgxHJ2xDIl0eKRKIhKM9ftzJBY4WR/r
         Ut+g==
X-Gm-Message-State: APjAAAWMLrlHaBXYG55hOzQ7aZ5z3mg++TG6r28/Xjh4Y4oMk3KtfNL4
        R2jWKVe/LkZ8uwHZfzcM0GfQnTrtexQsrYKeXxdE5fFtVco=
X-Google-Smtp-Source: APXvYqxIToY+8TpCLwNcWwVh/LJCubR5suYM92mFDs+DecbSM8vVHioMP746nRERsx1+fvDeDeF73XLr17ycQFA0URI=
X-Received: by 2002:a6b:641a:: with SMTP id t26mr2930359iog.3.1560445885690;
 Thu, 13 Jun 2019 10:11:25 -0700 (PDT)
MIME-Version: 1.0
From:   Mike Perez <miperez@redhat.com>
Date:   Thu, 13 Jun 2019 10:10:00 -0700
Message-ID: <CAFFUGJeRkyShwwZGav2Bpa6LhrZcWU+8CfKUfjtNg=c76HB4Ng@mail.gmail.com>
Subject: 06/13/2019 perf meeting recording is available!
To:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In case you missed today's meeting with Mark:

https://youtu.be/mtdOriQiQRs
https://pad.ceph.com/p/performance_weekly

Thanks!

--
Mike Perez (thingee)
