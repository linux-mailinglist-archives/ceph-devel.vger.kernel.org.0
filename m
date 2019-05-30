Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9A33034D
	for <lists+ceph-devel@lfdr.de>; Thu, 30 May 2019 22:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbfE3Udu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 May 2019 16:33:50 -0400
Received: from mail-qk1-f171.google.com ([209.85.222.171]:43132 "EHLO
        mail-qk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfE3Udu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 May 2019 16:33:50 -0400
Received: by mail-qk1-f171.google.com with SMTP id m14so4806971qka.10
        for <ceph-devel@vger.kernel.org>; Thu, 30 May 2019 13:33:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=boO2IbK4SwHXihiLlF7LO/+MwsPj5itdRH4aiBF9RWI=;
        b=HNxI0u71xPLNWTIFHUqflHj+JxmYcLGEZsOTSsXbfEaRC0XHMEl/ga/UGjd/GfhR0f
         3WM5NF6aWtxWlAALhkA6VqTtOFZ5xzGJ2yGmPE+wdwCvWl5LAxuxI9YJRYsR5I9zg85+
         4Jf6QSV+B4HZ5AGCG8Gri7VwaSBOFFc6vHZjAPrnop+llErwWTq0kNinFsoN9AHkRWdp
         gyovkaOFUaJGJV38lV17ufZe6NujT2bRWAlvXPJcZ8nCVrjyMd4irzuGivGlEz2DjavQ
         J2oLLJUkG6KGUFFT7wQ5GMeN5D680cOGfN4q1adf/+gQqv863E5yz6SsmUyjicUHlzcM
         nqRg==
X-Gm-Message-State: APjAAAVB1VHqfBN+L2SmLoZ6Q3rloIQqWyagtM3jXVfTucM8gGWyDgS2
        tEN3v1wzykj74TKLHd1u/onfg9qgBCHlHMvALHdnnA==
X-Google-Smtp-Source: APXvYqxJYMKw/yIyXj9yUCk8Mbz9qjnr9zVfwy6Y+xkcmy8MU2qZdZNx/i39lBk9s90rbcTZ6WV9jsg53LGkoHR4lIk=
X-Received: by 2002:a37:9207:: with SMTP id u7mr5268607qkd.357.1559248429429;
 Thu, 30 May 2019 13:33:49 -0700 (PDT)
MIME-Version: 1.0
References: <CAMMFjmF1SP9JnyeuqCtsS9KJKRO-1R+E+NkzO-kj6+pn=chfzw@mail.gmail.com>
In-Reply-To: <CAMMFjmF1SP9JnyeuqCtsS9KJKRO-1R+E+NkzO-kj6+pn=chfzw@mail.gmail.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 30 May 2019 13:33:23 -0700
Message-ID: <CA+2bHPa8GWqhqDnF7j32vQmainQPHC+b3B6qTentJF+KTfBMCg@mail.gmail.com>
Subject: Re: 13.2.6 QE Mimic validation status
To:     Yuri Weinstein <yweinste@redhat.com>
Cc:     Sage Weil <sweil@redhat.com>, "Durgin, Josh" <jdurgin@redhat.com>,
        "Dillaman, Jason" <dillaman@redhat.com>,
        "Sadeh-Weinraub, Yehuda" <yehuda@redhat.com>,
        "Development, Ceph" <ceph-devel@vger.kernel.org>,
        "Lekshmanan, Abhishek" <abhishek.lekshmanan@gmail.com>,
        Nathan Cutler <ncutler@suse.cz>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        ceph-qe-team <ceph-qe-team@redhat.com>,
        "Deza, Alfredo" <adeza@redhat.com>,
        Andrew Schoen <aschoen@redhat.com>, ceph-qa <ceph-qa@ceph.com>,
        Matt Benjamin <mbenjamin@redhat.com>,
        Sebastien Han <shan@redhat.com>,
        Brad Hubbard <bhubbard@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        Neha Ojha <nojha@redhat.com>,
        David Galloway <dgallowa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 23, 2019 at 1:00 PM Yuri Weinstein <yweinste@redhat.com> wrote:
> fs - Patrick, Venky approved?

Tracker tickets for failures:

http://tracker.ceph.com/issues/40093
https://tracker.ceph.com/issues/16881
http://tracker.ceph.com/issues/37613

> kcephfs - Patrick, Venky approved?

Needs rerun with -k testing.

> multimds - Patrick, Venky approved? (still running)

approved!

-- 
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
