Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8341F8CB
	for <lists+ceph-devel@lfdr.de>; Wed, 15 May 2019 18:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfEOQlM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 15 May 2019 12:41:12 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:38966 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbfEOQlM (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 15 May 2019 12:41:12 -0400
Received: by mail-pg1-f169.google.com with SMTP id w22so56505pgi.6
        for <ceph-devel@vger.kernel.org>; Wed, 15 May 2019 09:41:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LNNXVUdCWS/wL+jmZgiNe/15CjaWkBxkOetSl/Tmkbo=;
        b=jhB9HFplc43zj7QET4VgO5hpJp0P6a/3QwQsLN0ObFEQiifXVZOOYi6n/ilX0xLnZN
         KWNIdG/yIyOBLwy1LFo6kul7oW5eVdkTxjsaj4thribIkRkLnHgtNo1jFcIhQiKHyjpB
         zK6kknjczImkNzpZZYzMkJZsR95WOyoFc6FbKixwVxeIgUrBeuXvRKtOsxzPQ7IIQe8g
         XB9tMVQGUwkiPjwMQfGIm40/wo5VgjO5W+8iJ9ceynIlhod+pthzKmYGKHSXxBuQMSlL
         SAeqTOd7C9ZADI8fAM/V7rxJsNnL9GZQxDmveZUBcUohbHXlqTMx07RWb1LdZ/E7OcTs
         W4gw==
X-Gm-Message-State: APjAAAV71IBPj5KAUtYglp0dNFVTCyNtB5f4e6WU+yBgUlc89FbFYDE1
        HwrEb4uoodZKdXkdCtCOPuNi3OdFJKKzmEMlnag11ZnRwcw=
X-Google-Smtp-Source: APXvYqzRNJwWdJSHUp7AlPWW1aa6K6o+3Zcdo2+AZAxQ92CUhn8J4b1xAmPZPybDmWA54d3dSVeZAz+dw8ooWt4St4A=
X-Received: by 2002:a63:6e0b:: with SMTP id j11mr143801pgc.291.1557938471061;
 Wed, 15 May 2019 09:41:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAMMFjmGhw9i+-0DTPDk2-aCdGy3N0TEv2GiVOAJtn9qkC+2Jig@mail.gmail.com>
 <CAMMFjmH28geRKWpveQY3aWQCBp=_pFjOb_5YNchS_-bLxh_g+Q@mail.gmail.com>
 <CAMMFjmGkWVY4ozHUYJo3EWX0OBAGQOrBAJZRYkOnG60V5E5KcA@mail.gmail.com> <87woiruckt.fsf@suse.com>
In-Reply-To: <87woiruckt.fsf@suse.com>
From:   Yuri Weinstein <yweinste@redhat.com>
Date:   Wed, 15 May 2019 09:40:59 -0700
Message-ID: <CAMMFjmF6n4ApAmosJpgr1sYHji+sY-sXufWqQaoDY47Ns8REbg@mail.gmail.com>
Subject: Re: PRs for next mimic release
To:     Abhishek Lekshmanan <abhishek@suse.com>
Cc:     "Development, Ceph" <ceph-devel@vger.kernel.org>,
        Nathan Cutler <ncutler@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

One more was added https://github.com/ceph/ceph/pull/28096
