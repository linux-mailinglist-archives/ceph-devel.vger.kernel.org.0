Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 797B21818E2
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Mar 2020 13:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgCKM6O (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Mar 2020 08:58:14 -0400
Received: from mail-ua1-f50.google.com ([209.85.222.50]:45726 "EHLO
        mail-ua1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729232AbgCKM6N (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 11 Mar 2020 08:58:13 -0400
Received: by mail-ua1-f50.google.com with SMTP id 9so155687uav.12
        for <ceph-devel@vger.kernel.org>; Wed, 11 Mar 2020 05:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=/iIFDeLD27FBCiZhinuEe4mNrctDyofSEFGv0OKoJds=;
        b=phaRMHbykyXk7uO42DqIv7FfCaPb2mVNVw/H8Ct2wv26HxoTz9nZeawimJjJyt+Mqk
         wcw6tdf8/dDL2UyRTQbN/w8D6hgu+oPe4ay7qn56jQ7irvemwgZMBEBQPbm7QLBoG2Mc
         1u8KKz0aWIjXVH7WkNlsAt9F1D0rAGQ+tWZBTEG5+CfoEnx87theBeCFqYcJE9X066DK
         SA77/5jp7KOOXuKxWXxZ/1TPHX+abl0S5lgGcHPSC/xu607T0z6G6T1VoTms2RjAFkDY
         bGyGtoghfP42WhpnEyHs7FmpvoHUSZLo580HEVxaR1bNQaSk+nu/NCFfpcZlsB3r01IY
         pdpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=/iIFDeLD27FBCiZhinuEe4mNrctDyofSEFGv0OKoJds=;
        b=VjTcSBJc5ANnlxvTFll5cVXj7MDS9eT2rVp3UFOdZinkTD8iCxfbcqKTbhx/qGqSv0
         pcbJsPcW4UvYR9qYgYX6Xi9TsfQK9hs2kZ7GPpfZ83/vUerwxy0vK9drXDy/VEGGxWVL
         y2gN8H6FksXmyCpzqDf3EqflCqkcaaUjLPSGJW2KGCXJndUTBfZVzsbdncoBnJdmWS+R
         uMTSbfPUNh/Zz5D9TFYqV840KqUf8dtGm9KvZJwpFs2MlgcXVcFXPuWnu9YDe586l67S
         qvf0Fl0bSOgheUC7pAhPaEfCTsuBFRujZSC/DgET/FXMya1CfggNJc++SKkFf8793pPA
         NadA==
X-Gm-Message-State: ANhLgQ3goYbO/5fg3WLWW8L9W5JZ+8RZQ8Zmqshat80B3yTo427LpsMG
        FoaPzglBIIiaq61x8QDdAhp9wMmNDiMARTnAgnWNC37o
X-Google-Smtp-Source: ADFU+vte7JVJ3a1NrEdF8qsKW2RGNVUp1q4SZFNM1dDZScXyzp0UgwVircZkRdUDyBRu7+f6EJ/M8qGG7m1oeroH8vg=
X-Received: by 2002:ab0:2a1a:: with SMTP id o26mr1534356uar.62.1583931492579;
 Wed, 11 Mar 2020 05:58:12 -0700 (PDT)
MIME-Version: 1.0
From:   WeiGuo Ren <rwg1335252904@gmail.com>
Date:   Wed, 11 Mar 2020 20:57:59 +0800
Message-ID: <CAPy+zYVB6A+-CLWH6f5O=yX--C9ALvfgTZEcViZy-dXh+7GOsA@mail.gmail.com>
Subject: =?UTF-8?Q?RGW=3A_Can_RGW=2Dmulitisite_provide_sync_strategy=EF=BC=9F?=
To:     ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,cepher.
    I wonder  if  it provide synchronous bandwidth control. For
example, I can set the related parameters of rgw to control the
listening bandwidth. and Whether the bucket has priority when
synchronizing, the one with high priority should be synchronized
first=E3=80=82Does the community have these plans.

   thanks
