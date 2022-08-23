Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 039D259EF47
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Aug 2022 00:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiHWWb0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Aug 2022 18:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234303AbiHWWaO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 23 Aug 2022 18:30:14 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980748B9B0
        for <ceph-devel@vger.kernel.org>; Tue, 23 Aug 2022 15:28:56 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-333a4a5d495so416020847b3.10
        for <ceph-devel@vger.kernel.org>; Tue, 23 Aug 2022 15:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=z6Cu6NC49X90bkkDAyJKxFtOn1p21JsraKysxwpjoT0=;
        b=XuGSnZUP1CeMgpdbZGrx+ugJ2sLkZkbhTPbdRYFdIRc1Wi3g6jtzPA+i+UdQz80hte
         GX8RrPnIvzIHoLynLnvxScP+qFJkSU8DDoeWvqD7tjrnIEnnq059/j0N3VcuI+RXNhIo
         fPcl/tg6j9G6pcSwZyzKrlQEtCQTVs2I4/LqVY4PdiH3bjYLPt4bWIVDZv+Smnk+UNMq
         tbRmy8/fo64IltuDMHW4DOLp7mOBsuTX2cPKie9dEKjJCxg+fQ07qX4AaRB0vAEKPnh+
         vo1Musr4F1RB/vRnYSqOfrrQqkZKy9dlbewe2ROfTy+lU91f6dO773IOwE9x00vJzows
         IK4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=z6Cu6NC49X90bkkDAyJKxFtOn1p21JsraKysxwpjoT0=;
        b=iXLo5DQjBvqCMwJ8Om7XRIGzMc3+MceFMuNFbYtUXTjBXt10fv7l9dW6ykONWms32c
         HHsm6cebMYBBqpCpqYaTQvd3nPl/oiQzAQ7HOE+Y9faeYcVeXTz9NwwC1/5RPW0Fcdtl
         9Dr2p2GjjCMmOMrbDgPViTZ7Aj+JJfwkS8omIlG/2lUBEczRgt/FL0tEe8UAJFs9eLTk
         hbIG8t2B1dhX+6IY3mxM94FePb81p7y6Iz2HJxw4uWXEJawF61mZFu6M1AE38Njeu/8Z
         6IDZWPrIXDR7hP+oH8nYk47IPqs23LBJ0dhLpwnHNvvlmL01qLE8A3eCczceIFqPXbLV
         UBVA==
X-Gm-Message-State: ACgBeo0z+iMD9SkwJnJtLvaFWLDTrK9uVa7Xogf1QF056UAafj1cMQ9l
        n2TGQEdr07S16U9kgEgcjfdi+YBRIhDuw27l5JQ=
X-Google-Smtp-Source: AA6agR4XR9IwIUIyyhB942id9RXQsERRzolbLc3fezhPtZJGXYJyzyXXTTdjrXohWb7bWOMpOgZMIBLjEReW0m+Da2k=
X-Received: by 2002:a25:8886:0:b0:695:7f2d:2d68 with SMTP id
 d6-20020a258886000000b006957f2d2d68mr15638160ybl.281.1661293735545; Tue, 23
 Aug 2022 15:28:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:9295:b0:2ec:cd7b:3015 with HTTP; Tue, 23 Aug 2022
 15:28:55 -0700 (PDT)
Reply-To: charleswilliam6568@gmail.com
From:   charles william <adzapierro@gmail.com>
Date:   Tue, 23 Aug 2022 16:28:55 -0600
Message-ID: <CAGwaN2s9hn2xNTPzirKuTgnq2DD3WBM5kSaAqm8EQ0T9dn90Ew@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Sorry for intruding your privacy
