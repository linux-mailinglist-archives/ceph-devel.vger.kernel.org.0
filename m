Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F601BFB2
	for <lists+ceph-devel@lfdr.de>; Tue, 14 May 2019 00:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfEMW4y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 May 2019 18:56:54 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]:40366 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfEMW4y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 May 2019 18:56:54 -0400
Received: by mail-qt1-f169.google.com with SMTP id k24so11856923qtq.7
        for <ceph-devel@vger.kernel.org>; Mon, 13 May 2019 15:56:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=/5c1qI4ex4xHSQW3MFvxZDCdFSiBwf5qkLvTvUdFTZo=;
        b=abJ8e43RtSbAkBR4UJ5RYFZFqnAmfIrARx4e/03OPwcjKfltNs0fcMWvi2bK/QD9e6
         kW1rmklWivmxb9kaR/TV9+UsqKcltWCwNK55GTGhEbQQ81UoifBbba4f2e2+HUY0qHlR
         vUHvOlK1z9YAXRsyK+Dsx+M8aE4MwS7oeOFGWF3xsVqFwFPwytwJlvEJ7tNhEWVz/ADq
         ycYHjrokOvscJz4QiTaskndZLus1RXuoN+iYWNgYWUQr0IrhuciM8r4V+eGETYccxR7t
         QCyRwm9UAjWh7EvT6eSLRzmtoqhpovERbg/dw9oDkgQHzo4lBU9jHO2pwosj+2Ng6HZ5
         LNYQ==
X-Gm-Message-State: APjAAAXd7uLRtp3Wi37NnlhlPkqtRtM5nVZef2QDP4gYHFz1Taw/KzW6
        y2aF8ciDQy9j1Y2b37UMjFy+0IeQ7dUgFmF6jxI2jy5L
X-Google-Smtp-Source: APXvYqx72r8QWAMI47UWcSw/UlEHXuPhsLHSyNXVPOVJvpwbFbXEDuhrRgxgm1hGtzxmx7arNX3YctkFPKMRHE1pTOU=
X-Received: by 2002:ac8:27aa:: with SMTP id w39mr27202965qtw.227.1557788212894;
 Mon, 13 May 2019 15:56:52 -0700 (PDT)
MIME-Version: 1.0
From:   Alfredo Deza <adeza@redhat.com>
Date:   Mon, 13 May 2019 18:56:42 -0400
Message-ID: <CAC-Np1zOhGgBcj3f7BartvhWneY0BNUtyh2hxE_+LXKXe5uEOg@mail.gmail.com>
Subject: All Jenkins builds halted
To:     ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,

Just a quick note on Jenkins, we are undergoing a major outage which
we are trying to recover from. Our master jenkins was affected with a
malware, a new instance is being worked on and we expect this to be
fully operational tomorrow.

This means *new* builds and repos, Github PR checks, and formal Ceph
releases are impacted.

Once all systems are fully working, PRs will have to manually
re-trigger the jobs (I will follow up on how to do that).

Thanks for your patience while we work on this.

-Alfredo
