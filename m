Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97846742FA
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Jul 2019 03:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388155AbfGYBqp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Jul 2019 21:46:45 -0400
Received: from mail-lj1-f172.google.com ([209.85.208.172]:44193 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387866AbfGYBqp (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 Jul 2019 21:46:45 -0400
Received: by mail-lj1-f172.google.com with SMTP id k18so46343916ljc.11
        for <ceph-devel@vger.kernel.org>; Wed, 24 Jul 2019 18:46:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2csDHUwsfZ9vKiM6L0X2VwRtlMfkReR7eWIJEs97n9I=;
        b=VcXbGnaWLQ6uBxUJzKi9bp/t6nTFeCUUVNx4C9z/V8Mie3msmApZwchyYJyewO7iCi
         ok4Q9KW7/ERuJc+yiDBVAvXi1U9y0iqZ49Ht/I6FuldP0dXD/cr2zPxIHD3np8JuI2Ln
         r3A6a0VToqfXSjCHjMrAOL20PCBHNrPUoynlR815r8pX1CMhbjiabqLSBZsZ+YLkPZUF
         mK6BMLkXoRow8AQEZG1kTqBIqQGwatHHHzXq0jkiC9AG7oHRjJdSOhckzvX/DmUc8EF/
         E3HO9NeCHTMRaNrL4KZXO7lrnhpeB21toBV7vyNbuj5Vlh/MYgoMxRhxPR1kfcZt7Mdt
         S81w==
X-Gm-Message-State: APjAAAW/L7KMka4m4cNRzYavx2okIto11YuzDGf/BYvZDomX8NHUx+Da
        2J24gNKNFDynaMFeIR7pDafPVWRsrntYBeBLBFwNzR5pkeg=
X-Google-Smtp-Source: APXvYqxszjL8s/tRhzyDdOzkM5/i1GHPnre+UuCVcGNviquLsNiX8V+YilR76qNTDGKYDMEoR6kVzbotRmsTW1DX1oE=
X-Received: by 2002:a2e:9209:: with SMTP id k9mr43457830ljg.96.1564019203123;
 Wed, 24 Jul 2019 18:46:43 -0700 (PDT)
MIME-Version: 1.0
From:   Brad Hubbard <bhubbard@redhat.com>
Date:   Thu, 25 Jul 2019 11:46:31 +1000
Message-ID: <CAF-wwdEs76vga8ZwhpRLio7KQ-GDhVCGLj2NyAncLiaEAV24Lg@mail.gmail.com>
Subject: Static Analysis
To:     dev@ceph.io, ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Latest static analyser results are up on  http://people.redhat.com/bhubbard/

Weekly Fedora Copr builds are at
https://copr.fedorainfracloud.org/coprs/badone/ceph-weeklies/

-- 
Cheers,
Brad
