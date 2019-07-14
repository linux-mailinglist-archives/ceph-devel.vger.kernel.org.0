Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D93B681B3
	for <lists+ceph-devel@lfdr.de>; Mon, 15 Jul 2019 01:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbfGNXps (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 14 Jul 2019 19:45:48 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40699 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728853AbfGNXps (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 14 Jul 2019 19:45:48 -0400
Received: by mail-lj1-f196.google.com with SMTP id m8so14283316lji.7
        for <ceph-devel@vger.kernel.org>; Sun, 14 Jul 2019 16:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2csDHUwsfZ9vKiM6L0X2VwRtlMfkReR7eWIJEs97n9I=;
        b=CYasN77ZyB8Wld746df57basXO2zMlALeW6RItWX5z6+cFMOOznkDJLfA4ZnxdBPmt
         WWJuV2GbdsVgUeM9YxmamxWPcC6P3lu+IFkjwgMfhYA3A5Y+NZ77FGBUpQ1wWvjCSc2A
         HGXhBUYkf7W62hjM0fUc032yPFE0Ft8hVpAZmk2aqGTV7UV8dryNVyBuNu5BhCNxoCBi
         NAw/1iKUPCJxtcGCEL/Y0uCN6KBJr4gDFjr0lPMbysgo9zswa2X1DzqeD0NLUPs3Uf/C
         rqbfZ3thzEsNj/DLE5FvSRZmEkCMYo3X0073+X4VBQA8BpDFVy9YJpOs4/QukgFh3pXA
         +tLw==
X-Gm-Message-State: APjAAAV/suSghefNLtRZoINe/E64napZva5/op6odO/aLyLhM46Hb1E6
        kuCqs6cEWfLMgq1/Fu0fjBGczk5/gI1wvSkdDO0Am33in/w=
X-Google-Smtp-Source: APXvYqzI8/CXzhy1eXyf2LcP8cgJ30CWjPRmNuoTVl/Zp3vLh6KCmyO7BmyPgKyRV0WLmcyE2+Tqp7h+gHIp2hn2X1M=
X-Received: by 2002:a2e:9209:: with SMTP id k9mr11938847ljg.96.1563147946412;
 Sun, 14 Jul 2019 16:45:46 -0700 (PDT)
MIME-Version: 1.0
From:   Brad Hubbard <bhubbard@redhat.com>
Date:   Mon, 15 Jul 2019 09:45:35 +1000
Message-ID: <CAF-wwdEemLdc=3MPqSnYB_bCbyuDQ+fj2EiEJg0i-WyM+X-Dvw@mail.gmail.com>
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
