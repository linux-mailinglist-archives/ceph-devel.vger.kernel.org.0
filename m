Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB56686F55
	for <lists+ceph-devel@lfdr.de>; Fri,  9 Aug 2019 03:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404550AbfHIB2z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 8 Aug 2019 21:28:55 -0400
Received: from mail-lj1-f179.google.com ([209.85.208.179]:43165 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728032AbfHIB2z (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 8 Aug 2019 21:28:55 -0400
Received: by mail-lj1-f179.google.com with SMTP id y17so66074072ljk.10
        for <ceph-devel@vger.kernel.org>; Thu, 08 Aug 2019 18:28:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=jZDiiQCmxbdX562bUotsQvkWkvqZFJy2k3F8i589X7E=;
        b=JUI7r7ZEdwZu1kDnUibyZSP07datC+B538aVoETQwI8HoZmQ9oAMOms4YtLeDFN3mX
         kg7CPHC8zcvOwjfv/LYQzkWHz1E/HQZbdTcwNvDB+h9uliNJZTiN+Tgx2IPY37HEhngM
         3+XkysD5Zpr6I/dQDU3O/MSbdBc/HkKNwsiHCJw7/SGUDMEKvMz8QF5tuHGKnjWbdNYA
         lzAbBVWD3P+nzq+K/WU85lBwOSZCLVuhTKoJb9yhuD/tnUxbVJVzUnexzvT2NbitppSp
         GuxSpxj0waCkqIlNNyvUlgqSuj13FTI1eUijwpjXwVI+Ur2nrr/wa0kaYkY6jyjv6tlB
         up2Q==
X-Gm-Message-State: APjAAAWTArql9kLpQUrolclIt3hjiu2GBMpA+P2NB1l7vsJPURJk5i40
        CfvItk7e+iQ84UnE8lKxch25NyGstYuYwrJncmvilZ2Jj24=
X-Google-Smtp-Source: APXvYqzGF/GfT/7xTU1s/uMtx3drU9qlU8bOC78TDDRWI3cAepVDGjYiHgNFyWWSrx6wMUAQ7MclNwyA24v66ZMifTI=
X-Received: by 2002:a2e:9592:: with SMTP id w18mr1776688ljh.183.1565314133316;
 Thu, 08 Aug 2019 18:28:53 -0700 (PDT)
MIME-Version: 1.0
From:   Brad Hubbard <bhubbard@redhat.com>
Date:   Fri, 9 Aug 2019 11:28:42 +1000
Message-ID: <CAF-wwdELOSfn4x340MJutjUKZhw6uz=VtyqgpFR8gTAe9Ui4pQ@mail.gmail.com>
Subject: Current status of Coverity static scans
To:     dev@ceph.io, ceph-devel <ceph-devel@vger.kernel.org>
Cc:     xie.xingguo@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello all,

For the last couple of weeks I've been doing Coverity scans and
posting them with the results from the other static analysis I do each
week [1] I wanted to bring everyone up to speed on the current status
and why I'm doing it this way.

Quite some time ago now I took over the task of running the Coverity
scans but in January last year they stopped working with the version
that Coverity shipped and they have not worked since then with any
publicly available version. this coincided with our move to C++11 and
my investigation led me to believe that the version of Coverity
current at teh time lacked support for c++1*. My company does have a
subscription however and that gives us access to several versions
which are not publicly available. I tested with various versions and
found one that works and that is what I'm using to do the scans
currently. Unfortunately Coverity's website (dashboard) does not
support the uploading of results gathered with any version other than
what they ship publicly so we are stuck with the HTML results I
generate and host. I will be creating bug reports for the errors seen
during scanning with the publicly available version (which is a
*later* version than the working version) but how much priority they
will be given I have no idea. Previous attempts to contact support
have fallen on deaf ears so I'm not overly optimistic but we shall
see. It has taken considerable time and effort to get to this point
but various individuals have stated the importance of having these
results available so it has been, and remains, a priority for me as do
the other weekly scans I perform.

[1] http://people.redhat.com/bhubbard/

-- 
Cheers,
Brad
