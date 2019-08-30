Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3BAA2CDA
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Aug 2019 04:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfH3C3O (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 29 Aug 2019 22:29:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57430 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbfH3C3O (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 29 Aug 2019 22:29:14 -0400
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com [209.85.208.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 89C3C83F3B
        for <ceph-devel@vger.kernel.org>; Fri, 30 Aug 2019 02:29:14 +0000 (UTC)
Received: by mail-lj1-f197.google.com with SMTP id c2so664206ljf.11
        for <ceph-devel@vger.kernel.org>; Thu, 29 Aug 2019 19:29:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=R703X7UjGTTe9bulVzRBkfdZUqNSjdn8lO5UvSSze6M=;
        b=PeGyr3bGQm7ysxoeZAfCVw8160Uh+CTzYSEKuRRqEXapbP+go4mLCS8/CT0heKOamU
         z5eiR95fyGufccuWTQ9N9jFQtoZIZjMD++Yyj9zfC0vIQGHQlnHZlLqKoQoXzVGmvP+a
         cN98mPwV8IQzB6p/xHvJTG/GLP8uu22nvBIXUWbkP3adF4/w5MgRfx3SUlE/NFd+aHgi
         SAT/QstTdX0K5+sP7DQeM84pLF3KkBZtFUmMmtjA24n9IzVdtyoGubopU0obvLSXpSzJ
         YHgYKl7L3bfAQlkXjYzNpJAN4luJRiZGkg0tmEUMTCYWq05O/CERbimbNaDnX/eBVlBd
         sKbQ==
X-Gm-Message-State: APjAAAX7JONGnHfTB2IYTFrKYgry4Oxc+VCF8DtHTl8aVUC3cDNNXo4C
        jbtlFIYcePzDUYb0qzWM4hAJFEKUypJHWgjSOWC3oBsJphv5OZH+NIusmNZVmVztjdbZ2VeWqxC
        VLXJtyMHbZ+vQgTpxeijr9uRyJMLb7vI0TGaoCg==
X-Received: by 2002:a2e:b178:: with SMTP id a24mr7138004ljm.183.1567132152874;
        Thu, 29 Aug 2019 19:29:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxZFX/SF+nqwVpwNEEB0c6S7k8nCv86NlfN+MmnYaL4+igeu+kU6Cj0kRHKpqoa1HF9YYB7Xf6ydeUDDORa7mk=
X-Received: by 2002:a2e:b178:: with SMTP id a24mr7138000ljm.183.1567132152729;
 Thu, 29 Aug 2019 19:29:12 -0700 (PDT)
MIME-Version: 1.0
From:   Brad Hubbard <bhubbard@redhat.com>
Date:   Fri, 30 Aug 2019 12:29:01 +1000
Message-ID: <CAF-wwdHsBqsaz=UKsmP0iH5hk1oW8parnr8SXQ2utc5OGJrPyA@mail.gmail.com>
Subject: Static Analysis
To:     dev@ceph.io, ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Latest static analyser results are up on  http://people.redhat.com/bhubbard/

There is only an update to Coverity results this week since the
environment I use to run the other scans is broken and I need to set
up an alternate environment.

Weekly Fedora Copr builds are at
https://copr.fedorainfracloud.org/coprs/badone/ceph-weeklies/

-- 
Cheers,
Brad
