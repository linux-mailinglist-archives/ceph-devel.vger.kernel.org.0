Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23AB53C0C2
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Jun 2019 03:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389723AbfFKBGO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Jun 2019 21:06:14 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:44898 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388845AbfFKBGO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 10 Jun 2019 21:06:14 -0400
Received: by mail-pl1-f178.google.com with SMTP id t7so1715725plr.11
        for <ceph-devel@vger.kernel.org>; Mon, 10 Jun 2019 18:06:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=X+N7DLX3Zp9tYFqn7AFAlE/MLRrXDuGpJtyfv6hsl4Y=;
        b=HJQX7K6tbPAehqacBPPsugyHyI5YlW5BpZXTpLxJ1l/tDKwQazwHcFK3S3a2QrB7rY
         bRY+nvAGkcORvAmf9KVSlRHbbLuN+h3JsGVJF6oqt8DAXumOKlMN81/occkbWpuc3V6l
         95S2go3Zkts0rm42bR/Z4Ah75h/7q6DcxrcaXAUB8PWSnElB9PAVDWaXNbW545NMYrke
         LqZY24Fii8SNdkq3YIWE5DXIqkAwUqPFIaZ+Ha7F3w2lFQbIxl6aTWQIHKOL+2dAzJ8p
         HyvfX/gaXKGpR2Cj0zXAK4TLULw8zR9uf8zkSsz+BqwFqmm5nHkiMJRYX3hqbMdrEme6
         dDpQ==
X-Gm-Message-State: APjAAAVz3GIe4opsu7bUZmh2EIXKFD4XooKmoZAWU2zErBMIze/688oP
        LemgRN/tVcQlzj9KdIeSx5tbxcmFl8FxT85jTNtcXLn1JNc=
X-Google-Smtp-Source: APXvYqx+b1cRv8WKzMZR+tjFFN/XfafU/PM9QmUKEn12WEujjPAaJO+I8bdBnVwh0T7eVDsbny2SGWTE67pjA8VUWZ8=
X-Received: by 2002:a17:902:4481:: with SMTP id l1mr74596785pld.121.1560215173155;
 Mon, 10 Jun 2019 18:06:13 -0700 (PDT)
MIME-Version: 1.0
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Mon, 10 Jun 2019 18:06:02 -0700
Message-ID: <CAMMFjmHQ-cEeZcXzftCr_q=iYb8BjpUndtg2iWoGEN92EMqkZg@mail.gmail.com>
Subject: ubuntu 14.04 tests support
To:     "Development, Ceph" <ceph-devel@vger.kernel.org>,
        Zack Cerza <zcerza@redhat.com>,
        David Galloway <dgallowa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Latest changes to teuthology may prevent tests to be able to run on ubuntu 14.04

ref:
https://github.com/ceph/teuthology/commit/629f343dde18c2fad371bca0963b731c6e85b079
https://github.com/ceph/teuthology/pull/1294#issuecomment-500568491

(Zack and David have more on why)

There are some tests that have ubuntu 14.04 configurations specified ATM.
Question - is it OK to remove references from those suites ?
Do we have any use cases when ubuntu 14.04 must be supported?

Thx
YuriW
