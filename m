Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E456FDE9B
	for <lists+ceph-devel@lfdr.de>; Wed, 10 May 2023 15:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237140AbjEJNbm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 May 2023 09:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbjEJNbk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 10 May 2023 09:31:40 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053D144A8
        for <ceph-devel@vger.kernel.org>; Wed, 10 May 2023 06:31:40 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id ada2fe7eead31-42c38a6daf3so4828399137.3
        for <ceph-devel@vger.kernel.org>; Wed, 10 May 2023 06:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683725499; x=1686317499;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OUNfFPXRbwy3GrkhoYJ9XNs1tL5HOfwzelho1mqOHSk=;
        b=R16g9MhrsGzP9n9SIj/ONbXB0m57OaYCQ3ouj4ghzDfS80nEWNqip02nHSN7iPcGkB
         0dMn9Sf1ppyF8ZHOtpJzmIjbzJB9L1W+nd7N+SALFSUWjRwasdOUw/Gt2Taqrx9Tq7Cs
         /H9HyVIZjG6wYcI8YI0dJ+3yr3fJd7RrvqZn9I1cK1ASQbjOMX9H7vzjwgo2VrE0ZlkK
         JXZr9JhPRwoUIb0Xx4+mbkgSLJQV1BamzIJDoogDeqRynyWlOCR64c4WmLChLNuzrFgR
         5uCpa9poTPtIwR/hlzWabSr4BjZ7vLcR0A8hRDwS1RalQ/8XeQniOiI9YPq6WdI7Fei/
         +9JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683725499; x=1686317499;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OUNfFPXRbwy3GrkhoYJ9XNs1tL5HOfwzelho1mqOHSk=;
        b=Pj8P+y4ccKXS4lhKzHvi2BDc+AghjrthmzkE+pNM4iLCc0YWY0hFOWSBNg7s52bEVt
         xh3Nrtue3N2xltlacLVQGeVl1RLw5ThOUaCFmZNOHdCQCO7bnyyTMvyRn5/fIq+hzl7n
         cRzYiB6tMAHwPu/TYX+uJcMPDygXJYqXTkgO0q6xDUiTtcodP+QtNCeQ3Td0oZAX88lW
         No1Y0sM9DIy+s22cR4SIrJPDTfndSlWzztBRIjTsrAaq8Dknz2S+eWmkPEFTWX4FsHCm
         TxX1nHsNTqj9Pby4WnMFgDxRa4OrWilUqaqc24ALB8hk2ALjKlzVYOdhbWxdaGICNUYh
         TUGw==
X-Gm-Message-State: AC+VfDz+JcJAKA/2r3HsFH58ClqW8oRChBD1Q5uFYXb4IPwSnJd/WCu4
        YCwZ5EH/Gzk4dzDEpQdPrGbW8+FnGVP/fMICZ3U=
X-Google-Smtp-Source: ACHHUZ59TUvINFgO8pp3gPw01MDLDbFcnX3pyo/jQb6Xy0KZ8AT4hmbje98J5B1rkJj05cdV8bKvyUQv8NgtSglORaU=
X-Received: by 2002:a67:fc81:0:b0:434:763c:c42 with SMTP id
 x1-20020a67fc81000000b00434763c0c42mr5991634vsp.15.1683725499045; Wed, 10 May
 2023 06:31:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:caa8:0:b0:3b6:4c85:fa09 with HTTP; Wed, 10 May 2023
 06:31:38 -0700 (PDT)
Reply-To: contact.ninacoulibaly@inbox.eu
From:   nina coulibaly <ninacoulibaly13.info@gmail.com>
Date:   Wed, 10 May 2023 06:31:38 -0700
Message-ID: <CACTFrC0WrZ6Y_x3k0r6f3P=9Phti6wvsAmOiB=-kNpEQUNne9w@mail.gmail.com>
Subject: from nina coulibaly
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.6 required=5.0 tests=BAYES_50,DEAR_SOMETHING,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dear sir,

Please grant me permission to share a very crucial discussion with
you. I am looking forward to hearing from you at your earliest
convenience.

Mrs. Nina Coulibaly
