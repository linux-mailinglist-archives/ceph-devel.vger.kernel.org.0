Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD55857C9
	for <lists+ceph-devel@lfdr.de>; Thu,  8 Aug 2019 03:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730505AbfHHBvF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Aug 2019 21:51:05 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:35418 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730038AbfHHBvF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Aug 2019 21:51:05 -0400
Received: by mail-lj1-f178.google.com with SMTP id x25so87388641ljh.2
        for <ceph-devel@vger.kernel.org>; Wed, 07 Aug 2019 18:51:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=R703X7UjGTTe9bulVzRBkfdZUqNSjdn8lO5UvSSze6M=;
        b=j8qem7h3X+8Ng10p629u3dYAc/9U21oZdQkPl3Qjsb38INpy9NiVFEZMzNVpjKk8Cn
         aIc7+/dJWByvZMlgnzT946ZQUaqPBCrWI4Ee5RkgfsQK8x7eHvJY/PSM1RTjq/wmXp8X
         oQz/W6aI5YO2jLfjcdj7M2gqy6WMTzcQM/+OZLKi1/yt2fG7pn+o7A2EK1vZPbJnYSC7
         BMzrBvxMKwwh3gfBnMqPWNtaqEOr2UDBdHdE5mP4bAh5WrKZhq8AxGjPATKc87Y28/4w
         X987cIgQnogtQM367rCZn19B68UrcdMbJCWUI0ZZ6NQOle7/hJvl2tJpMP0eK9Q+p5wP
         c+AQ==
X-Gm-Message-State: APjAAAX4K8C1Bg7CbKBwTJwFZnYqs9KRJdfW4/xWXom2jf2L6j3N1mry
        neHMkCRwTzIFpoy+A7ZrJs4wBpn7KOaoULY5OFfxnDCdBAU=
X-Google-Smtp-Source: APXvYqzCFkePJvIawqBWN+K2rNnHl3OqfKnv1HfjvVK9/P5Q5PMs6hslKsRXLX602L7k9aWPwToHfTwXZdbkD1KnOr8=
X-Received: by 2002:a2e:93c8:: with SMTP id p8mr6450638ljh.6.1565229062701;
 Wed, 07 Aug 2019 18:51:02 -0700 (PDT)
MIME-Version: 1.0
From:   Brad Hubbard <bhubbard@redhat.com>
Date:   Thu, 8 Aug 2019 11:50:51 +1000
Message-ID: <CAF-wwdGH9LSWBC7WnRcu70GZAkqvKjbZYWY_B3KWDPHT-_bZ2A@mail.gmail.com>
Subject: Static Analysis
To:     dev@ceph.io, ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Latest static analyser results are up on  http://people.redhat.com/bhubbard/

There is only an update to Coverity results this week since the
environment I use to run the other scans is broken and I need to set
up an alternate environment.

Weekly Fedora Copr builds are at
https://copr.fedorainfracloud.org/coprs/badone/ceph-weeklies/

-- 
Cheers,
Brad
