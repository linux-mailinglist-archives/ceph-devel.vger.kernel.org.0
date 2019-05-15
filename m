Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 576291E9D0
	for <lists+ceph-devel@lfdr.de>; Wed, 15 May 2019 10:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbfEOIH1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 May 2019 04:07:27 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:45601 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfEOIH0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 15 May 2019 04:07:26 -0400
Received: by mail-pf1-f182.google.com with SMTP id s11so940977pfm.12
        for <ceph-devel@vger.kernel.org>; Wed, 15 May 2019 01:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gaul.org; s=google;
        h=from:date:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=G1pFqKROGQUAoNA5Dy6n1Kho2vi//nf7z4AYRKye5GI=;
        b=Jnmjo+P00VS9Wm5zTOq7frKwcabeUw1J5tmf6v1okVDA8psg6i0mTB2i0SqSIrhv5D
         gjHdVNVHF/eTMTOQtZpmWqpIpp0kHN074vpAqkZFdbz7Km5PQ4VNoU+WXdE9ZaGJ/DcM
         OraVsEEJVpmNGDIdhhUMrh1sgWWyMfg08bKgoY6EReAjEEJSsuOKnzl5esEsiYdKtKST
         OTKZfhuE48/KgAzLIdbhHvPjneeTrlenwbBf84CmGp+CeXpwNWwH/KvGWHluJ43sILvZ
         lZZD0K8NsDeEGeijobozPtLOw2OUFmHjDnvhfaiQMOCBgjh/QB6Ysjnjs/6wbab1SRcs
         O+cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=G1pFqKROGQUAoNA5Dy6n1Kho2vi//nf7z4AYRKye5GI=;
        b=K1OxQgcVkE5+012Pq1gBC8qUWn7V3cphCxF+FfVsPCXORlMnoUQE7Q6QUSD/qB5+B7
         iMHI8DzrbU1WZxx9+ICAxiWAEDltCBRHE9skRqmNRmIlRsDh3Z4/BcboFtfcNQT5HkHT
         7hOkZxhiJqH7ijZfCeyemGE4Rz9LSRDetdtGWQAZFyVDP1hhE+cf1sEecvl4BnMV3gK6
         AWx3QrHsChSeQPy5HGJjaKLe4sx7anUEj45BjrC5QE+x2TjeZFUMWDv/Sg/mTHbf6kAu
         o7bS9eHIKOSLU34IUhZyMW76lPi8LAc7mNZb/jYzOrjh9ylD5SD3BCZE7vdhhCNtJZZ4
         GcYw==
X-Gm-Message-State: APjAAAX6lHxJvEMa/AeV56fcyzQIr4qNv2eaOp8zh8O4Ypu+TxeFTRLD
        JpZOkC0bR9dtjrqNxXqawBlqlyaE8Tr7dg==
X-Google-Smtp-Source: APXvYqzihYdWcGQlNfzPo98SG5QZkpDW//lqRvdOpEuwbXRSIbFQ3qnjP5ZRHteB1DUOAo1RHmQ1Yg==
X-Received: by 2002:a63:5c4c:: with SMTP id n12mr42811233pgm.111.1557907645787;
        Wed, 15 May 2019 01:07:25 -0700 (PDT)
Received: from sherlock ([117.2.56.17])
        by smtp.gmail.com with ESMTPSA id d186sm2527847pfd.183.2019.05.15.01.07.23
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 15 May 2019 01:07:24 -0700 (PDT)
From:   Andrew Gaul <gaul@gaul.org>
X-Google-Original-From: Andrew Gaul <andrew@gaul.org>
Date:   Wed, 15 May 2019 15:07:16 +0700
To:     ceph-devel@vger.kernel.org
Subject: s3-tests development 2019
Message-ID: <20190515080716.GA11147@sherlock>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Does s3-tests still merge PRs from non-Ceph developers?  While I have
contributed to this project in the past, the GitHub repository currently
has 55 open PRs with 7 opened by me[1], some for almost 5 years.  We
previously discussed this in 2015[2] and made some progress but have
stalled again.  I prefer to work with the upstream project but if this
is not possible please communicate this expectation, preferably in the
README.  Several S3 implementations such as S3Proxy and swift3 use
s3-tests and it would be a shame if we could not collaborate.

[1] https://github.com/ceph/s3-tests/pulls/gaul
[2] https://marc.info/?l=ceph-devel&m=142500510918349&w=2

-- 
Andrew Gaul
http://gaul.org/
