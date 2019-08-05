Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0318380FB6
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Aug 2019 02:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfHEAe0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 4 Aug 2019 20:34:26 -0400
Received: from mail-lf1-f45.google.com ([209.85.167.45]:40022 "EHLO
        mail-lf1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfHEAe0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 4 Aug 2019 20:34:26 -0400
Received: by mail-lf1-f45.google.com with SMTP id b17so56577209lff.7
        for <ceph-devel@vger.kernel.org>; Sun, 04 Aug 2019 17:34:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=oywGvVY06jjZnl8TPll7hDuyCanRT+4BR75I54HQ7vE=;
        b=W7zbV29MWWBh5nPiumpsQ+5bbbQ83huGUeuhCk5wYENjk9oeyDjvboIyID5sKT2RK2
         fd5IWn9N+Vg4+Dzu/x64jiIpU8W4MIUEazHJEcfxyf/YT67acYtkUBjXH8RQXEshG3OU
         h4L2Isfs0pe14YLQ4Vz5BBsAGRVYOl2A49AE5CGOqva5Gjz6CZ0S3L/lX6owcZlRZokj
         XTfBhuC1+V50xI2sCgz6gEY1avvmatlbyV77ctQh3pgwvb79g9i5qPf2T4M76L2CtV+e
         ZPr/X8tU3cYvTEsgT1Dlt7+cLtY9ydMuJTh2MJM6FfcDVT2gx/mEpgHzMRwTu1HnoS6J
         UEEg==
X-Gm-Message-State: APjAAAWKxuYwemk/dJ4LcscdRkqpiR8M6mNa1Ja/55+vUpHUKUyOpwnf
        Nd6eHqp5JZ4T911KzNL8gGkGjeUdrjfn607inimQQEuKWDY=
X-Google-Smtp-Source: APXvYqyiKP38OUjZDLCDB76hG2RjsYNH4xOtPsWHq9M5kczzX+8mdx/D7JWxJbJ4aP25DPvmy3Jtk772Ed8+KV6ViqM=
X-Received: by 2002:a19:7509:: with SMTP id y9mr69540720lfe.117.1564965264373;
 Sun, 04 Aug 2019 17:34:24 -0700 (PDT)
MIME-Version: 1.0
From:   Brad Hubbard <bhubbard@redhat.com>
Date:   Mon, 5 Aug 2019 10:34:13 +1000
Message-ID: <CAF-wwdH144v=+pkerFvvQ4g6PHCG3axgbEuaGsDUTvhrPsf4uw@mail.gmail.com>
Subject: Static Analysis, including Coverity results
To:     dev@ceph.io, ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Latest static analyser results are up on  http://people.redhat.com/bhubbard/

This week's run includes Coverity results. I'll be sending a separate
email about the status of Coverity results in the next couple of days.

Weekly Fedora Copr builds are at
https://copr.fedorainfracloud.org/coprs/badone/ceph-weeklies/

-- 
Cheers,
Brad
